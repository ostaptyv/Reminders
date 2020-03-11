//
//  RICreateReminderViewController.m
//  Reminders
//
//  Created by Ostap on 24.11.2019.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "RICreateReminderViewController.h"
#import "RIReminderRaw.h"
#import "RIImageAttachmentCollectionViewCell.h"
#import "RIConstants.h"
#import "RIResponse.h"
#import "RIError.h"
#import "RINSError+ReminderError.h"
#import "RINSFileManager+ImageSaving.h"
#import "RICoreDataStack.h"
#import "RIAppDelegate.h"

@interface RICreateReminderViewController ()

@property (strong, nonatomic) RICoreDataStack *coreDataStack;

@end

@implementation RICreateReminderViewController

#pragma mark - Property getters

- (RICoreDataStack *)coreDataStack {
    RIAppDelegate *appDelegate = (RIAppDelegate *)UIApplication.sharedApplication.delegate;
    
    return appDelegate.coreDataStack;
}

#pragma mark - View did load method

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
    
    [NSFileManager.defaultManager createGlobalImageStoreDirectory];
}

#pragma mark - Creating instance

+ (RICreateReminderViewController *)instance {
    NSString *stringClass = NSStringFromClass(self.class);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:stringClass bundle:nil];
    
    return [storyboard instantiateInitialViewController];
}

#pragma mark - Set default property values

- (void)setDefaultPropertyValues {
    self.arrayOfImages = [NSMutableArray new];
}

#pragma mark - UI setup

- (void)setupNavigationBar {
    UIBarButtonItem *doneItem = [self makeDoneItem];
    UIBarButtonItem *cameraItem = [self makeCameraItem];
    UIBarButtonItem *cancelItem = [self makeCancelItem];
    
    self.navigationItem.rightBarButtonItems = @[doneItem, cameraItem];
    self.navigationItem.leftBarButtonItem = cancelItem;
}

- (void)setupScrollView {
    self.scrollView.contentInset = UIEdgeInsetsMake(kScrollViewTopContentInset, 0.0, kScrollViewBottomContentInset, 0.0);
}

- (UIBarButtonItem *)makeDoneItem {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
}

- (UIBarButtonItem *)makeCameraItem {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraButtonTapped)];
}

- (UIBarButtonItem *)makeCancelItem {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
}

- (void)setupTextView {
    self.textView.delegate = self;
    
    [self.textView becomeFirstResponder];
}

- (void)setupCollectionView {
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, kCollectionViewSectionInset, 0, kCollectionViewSectionInset);
}

#pragma mark - Target-Action methods

- (void)doneButtonTapped {
    BOOL success;
    RIReminderRaw *reminder;
    NSError *error;
    
    if ([self.textView.text isEqualToString:@""] && self.arrayOfImages.count == 0) {
        success = NO;
        reminder = nil;
        error = [NSError generateReminderError:RIErrorCreateReminderEmptyContent];
    } else {
        NSString *text = self.textView.text;
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0.0];
        NSMutableArray<UIImage *> *arrayOfImages = [self.arrayOfImages mutableCopy];
        
        success = YES;
        reminder = [[RIReminderRaw alloc] initWithText:text dateInstance:date arrayOfImages:arrayOfImages];
        error = nil;
        
        [self createReminder:reminder];
    }
    
    RIResponse *response = [[RIResponse alloc] initWithSuccess:success result:reminder error:error];
    
    NSDictionary<NSString *, id> *userInfo = @{
        RICreateReminderViewControllerResponseKey: response
    };
    
    [self sendNotificationForName:RICreateReminderViewControllerDidCreateReminderNotification userInfo:userInfo];
}

- (void)cameraButtonTapped {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    NSString *mediaType = (NSString *)kUTTypeImage;
    
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        return;
    }
    if (![[UIImagePickerController availableMediaTypesForSourceType:sourceType] containsObject:mediaType]) {
        return;
    }
    
    UIImagePickerController *picker = [UIImagePickerController new];
    
    picker.delegate = self;
    picker.sourceType = sourceType;
    picker.mediaTypes = @[mediaType];
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)cancelButtonTapped {
    [self cancelReminderCreation];
}

#pragma mark - Cancel button handling

- (void)cancelReminderCreation {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure you want to delete?" message:@"All unsaved data will be deleted if you proceed" preferredStyle:UIAlertControllerStyleAlert];
    
    __typeof__(self) __weak weakSelf = self;
    UIAlertController * __weak weakAlertController = alertController;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf sendNotificationForName:RICreateReminderViewControllerDidPressAlertCancelNotification userInfo:nil];
        [weakAlertController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *proceedAction = [UIAlertAction actionWithTitle:@"Proceed" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf sendNotificationForName:RICreateReminderViewControllerDidPressAlertProceedNotification userInfo:nil];
        [weakAlertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:proceedAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Image picker delegate methods

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

#pragma mark - Text view delegate methods

- (void)textViewDidChange:(UITextView *)textView {
    CGSize newSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, CGFLOAT_MAX)];

    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, newSize.width, newSize.height);

    [self.textView scrollRangeToVisible:self.textView.selectedRange];
}

#pragma mark - Collection view delegate & data source methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [self handleArrayOfImagesCountChange:self.arrayOfImages.count];
    
    return self.arrayOfImages.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RIImageAttachmentCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:RIImageAttachmentCollectionViewCell.reuseIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = self.arrayOfImages[indexPath.item];
    
    [cell setupUI];
    
    return cell;
}

#pragma mark - Scroll view delegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.arrayOfImages.count == 0 && self.textView.isFirstResponder) {
        return;
    }
    
    [self.textView endEditing:YES];
}

#pragma mark - Hide collection view depending on 'arrayOfImages' count

- (void)handleArrayOfImagesCountChange:(NSUInteger)newCount {
    if (newCount == 0) {
        self.collectionView.hidden = YES;
    } else {
        self.collectionView.hidden = NO;
    }
}

#pragma mark - Keyboard management

- (void)adjustViewFrameAsKeyboardShows {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notifiaction {
    NSDictionary *userInfo = notifiaction.userInfo;
    
    NSValue *value = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardFrameSize = [value CGRectValue].size;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(kScrollViewTopContentInset, 0.0, keyboardFrameSize.height, 0.0);
}

- (void)keyboardWillHide:(NSNotification *)notifiaction {
    self.scrollView.contentInset = UIEdgeInsetsMake(kScrollViewTopContentInset, 0.0, 0.0, 0.0);
}

#pragma mark - Managing remove attachment button behavior

- (void)registerForRemoveButtonTappedNotification {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(removeAttachmentButtonTapped:) name:RIRemoveAttachmentButtonTappedNotification object:nil];
}

- (void)removeAttachmentButtonTapped:(NSNotification *)notification {
    UIImage *imageToRemove = notification.userInfo[@"image"];
    
    for (UIImage *image in self.arrayOfImages) {
        if (image != imageToRemove) {
            continue;
        }
        
        [self.arrayOfImages removeObject:image];
        [self.collectionView reloadData];
        
        break;
    }
}
 
#pragma mark - Create reminder method

- (void)createReminder:(RIReminderRaw *)reminderRaw {
    NSURL *localDirectoryUrl = [NSFileManager.defaultManager createLocalImageStoreDirectory];
    NSMutableArray<NSString *> *arrayOfImagePaths = [NSMutableArray new];
    
    for (UIImage *image in reminderRaw.arrayOfImages) {
        NSData *pngData = UIImagePNGRepresentation(image);
        NSURL *imageUrl = [NSFileManager.defaultManager createImageFileForURL:localDirectoryUrl contents:pngData];
        NSString *imagePath = [self makePathStringFromImageURL:imageUrl];
        
        [arrayOfImagePaths addObject:imagePath];
    }
    
    RIReminder *reminder = [[RIReminder alloc] initWithContext:self.coreDataStack.managedObjectContext];
    
    reminder.text = reminderRaw.text;
    reminder.date = reminderRaw.date;
    reminder.arrayOfImagePaths = [arrayOfImagePaths copy];
    
    [self.coreDataStack saveData];
}

#pragma mark - Private methods for internal purposes

- (NSString *)makePathStringFromImageURL:(NSURL *)url {
    NSArray<NSString *> *pathComponents = url.pathComponents;
    
    if (pathComponents.count >= kTasksListNumberOfLastURLPathComponents) {
        NSRange range = NSMakeRange(pathComponents.count - kTasksListNumberOfLastURLPathComponents, kTasksListNumberOfLastURLPathComponents);
        pathComponents = [pathComponents subarrayWithRange:range];
    }
    
    return [pathComponents componentsJoinedByString:@"/"];
}

- (void)sendNotificationForName:(NSString *)notificationName userInfo:(NSDictionary<NSString *, id> *)userInfo {
    NSNotification *notification = [[NSNotification alloc] initWithName:notificationName object:self userInfo:userInfo];
    
    [NSNotificationCenter.defaultCenter postNotification:notification];
}

@end
