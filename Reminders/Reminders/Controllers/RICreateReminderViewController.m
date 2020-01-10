//
//  RICreateReminderViewController.m
//  Reminders
//
//  Created by Ostap on 24.11.2019.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "RICreateReminderViewController.h"
#import "RIReminder.h"
#import "RIImageAttachmentCollectionViewCell.h"
#import "RIConstants.h"

//CONTEXTS:
void *RIMutableArrayCountContext = &RIMutableArrayCountContext;

@interface RICreateReminderViewController ()

@property NSMutableArray<UIImage *> *arrayOfImages;

@end

@implementation RICreateReminderViewController

#pragma mark -viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaultPropertyValues];
    
    [self setupNavigationBar];
    [self setupScrollView];
    [self setupTextView];
    [self setupCollectionView];
    
    self.scrollView.delegate = self;
    
    [self handleArrayOfImagesCountChange:self.arrayOfImages.count];
    [self adjustViewFrameAsKeyboardShows];
    
    [self registerForRemoveButtonTappedNotification];
}

#pragma mark +instance

+ (UINavigationController *)instance {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RICreateReminderViewController" bundle:nil];
    
    return [storyboard instantiateInitialViewController];
}

#pragma mark Set default property values

- (void)setDefaultPropertyValues {
    self.arrayOfImages = [NSMutableArray new];
}

#pragma mark UI setup

- (void)setupNavigationBar {
    UIBarButtonItem *doneIcon = [self makeDoneIcon];
    UIBarButtonItem *cameraIcon = [self makeCameraIcon];
    
    self.navigationItem.rightBarButtonItems = @[doneIcon, cameraIcon];
}

- (void)setupScrollView {
    self.scrollView.contentInset = UIEdgeInsetsMake(scrollViewTopContentInset, 0.0, 0.0, 0.0);
}

- (UIBarButtonItem *)makeDoneIcon {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
}

- (UIBarButtonItem *)makeCameraIcon {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraButtonTapped)];
}

- (void)doneButtonTapped {
    if (![self.textView.text isEqualToString:@""]) {
        NSString *text = self.textView.text;
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0.0];
        NSMutableArray<UIImage *> *arrayOfImages = [self.arrayOfImages mutableCopy];
        
        RIReminder *newReminder = [[RIReminder alloc] initWithText:text dateInstance:date arrayOfImages:arrayOfImages];
        
        if (![self.delegate respondsToSelector:@selector(didCreateReminder:)]) { return; }
        
        [self.delegate didCreateReminder:newReminder];
    }
    
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (void)cameraButtonTapped {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    NSString *mediaType = (NSString *)kUTTypeImage;
    
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) { return; }
    if (![[UIImagePickerController availableMediaTypesForSourceType:sourceType] containsObject:mediaType]) { return; }
    
    UIImagePickerController *picker = [UIImagePickerController new];
    
    picker.delegate = self;
    picker.sourceType = sourceType;
    picker.mediaTypes = @[mediaType];
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)setupTextView {
    self.textView.delegate = self;
    
    [self.textView becomeFirstResponder];
}

- (void)setupCollectionView {
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, collectionViewSectionInset, 0, collectionViewSectionInset);
}

#pragma mark Image picker delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    [self.arrayOfImages addObject:image];
    [self handleArrayOfImagesCountChange:self.arrayOfImages.count];
    
    [self.collectionView reloadData];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Text view delegate methods

- (void)textViewDidChange:(UITextView *)textView {
    CGSize newSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, CGFLOAT_MAX)];

    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, newSize.width, newSize.height);

    [self.textView scrollRangeToVisible:self.textView.selectedRange];
}

#pragma mark Collection view delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayOfImages.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RIImageAttachmentCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:RIImageAttachmentCollectionViewCell.reuseIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = self.arrayOfImages[indexPath.item];
    
    [cell setupUI];
    
    return cell;
}

#pragma mark Scroll view delegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.arrayOfImages.count == 0 && self.textView.isFirstResponder) { return; }
    
    [self.textView endEditing:YES];
}

#pragma mark Hide collection view depending on 'arrayOfImages' count

- (void)handleArrayOfImagesCountChange:(NSUInteger)newCount {
    if (newCount == 0) {
        self.collectionView.hidden = YES;
    }
    
    else {
        self.collectionView.hidden = NO;
    }
}

#pragma mark Keyboard management

- (void)adjustViewFrameAsKeyboardShows {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notifiaction {
    NSDictionary *userInfo = notifiaction.userInfo;
    
    NSValue *value = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardFrameSize = [value CGRectValue].size;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(scrollViewTopContentInset, 0.0, keyboardFrameSize.height, 0.0);
}

- (void)keyboardWillHide:(NSNotification *)notifiaction {
    self.scrollView.contentInset = UIEdgeInsetsMake(scrollViewTopContentInset, 0.0, 0.0, 0.0);
}

- (void)registerForRemoveButtonTappedNotification {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(removeAttachmentButtonTapped:) name:RIRemoveAttachmentButtonTappedNotification object:nil];
}

- (void)removeAttachmentButtonTapped:(NSNotification *)notification {
    UIImage *imageToRemove = notification.userInfo[@"image"];
    
    for (UIImage *image in self.arrayOfImages) {
        if (image != imageToRemove) { continue; }
        
        [self.arrayOfImages removeObject:image];
        
        [self.collectionView reloadData];
        
        break;
    }
}

@end
