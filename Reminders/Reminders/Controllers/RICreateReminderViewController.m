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

@interface RICreateReminderViewController ()

@property (strong, nonatomic) void (^completionHandler)(RIResponse *, __weak UIViewController *);

@end

@implementation RICreateReminderViewController

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
}

#pragma mark - Creating instance

+ (UINavigationController *)instanceWithCompletionHandler:(void (^)(RIResponse *, __weak UIViewController *))completionHandler {
    NSString *stringClass = NSStringFromClass(self.class);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:stringClass bundle:nil];
    
    UINavigationController *navigationController = [storyboard instantiateInitialViewController];
    
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    RICreateReminderViewController *createReminderVc = navigationController.viewControllers.firstObject;
    
    createReminderVc.completionHandler = completionHandler;
    
    return navigationController;
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
    }
    
    RIResponse *response = [[RIResponse alloc] initWithSuccess:success result:reminder error:error];
    
    if ([self.delegate respondsToSelector:@selector(didCreateReminderWithResponse:viewController:)]) {
        [self.delegate didCreateReminderWithResponse:response viewController:self];
    }
    
    if (self.completionHandler == nil) {
        return;
    }
    
    self.completionHandler(response, self);
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
    [self cancelReminderCreationShowingAlert:self.showsAlertOnCancel];
}

#pragma mark - Cancel button handling

- (void)cancelReminderCreationShowingAlert:(BOOL)showsAlert {
    if (showsAlert) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure you want to proceed?" message:@"All unsaved data will be deleted" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
        {
            if ([self.delegate respondsToSelector:@selector(didPressAlertCancelButton)]) {
                [self.delegate didPressAlertCancelButton];
            }
            
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *proceedAction = [UIAlertAction actionWithTitle:@"Proceed" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action)
        {
            if ([self.delegate respondsToSelector:@selector(didPressAlertProceedButtonOnParent:)]) {
                [self.delegate didPressAlertProceedButtonOnParent:self];
            }
            
            [self sendResponseWithFailure];
            
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:proceedAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self sendResponseWithFailure];
    }
}

- (void)sendResponseWithFailure {
    BOOL success = NO;
    RIReminder *reminder = nil;
    NSError *error = [NSError generateReminderError:RIErrorCreateReminderUserCancel];
    
    RIResponse *response = [[RIResponse alloc] initWithSuccess:success result:reminder error:error];
    
    if (self.completionHandler == nil) {
        return;
    }
    
    self.completionHandler(response, self);
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

#pragma mark - Collection view delegate methods

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

@end
