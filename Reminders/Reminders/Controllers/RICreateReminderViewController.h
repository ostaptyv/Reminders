//
//  RICreateReminderViewController.h
//  Reminders
//
//  Created by Ostap on 24.11.2019.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RICreateReminderViewController.h"
#import "RICreateReminderDelegate.h"
#import "RIReminder.h"
#import "RIResponse.h"

@interface RICreateReminderViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UITextViewDelegate, UICollectionViewDataSource>

@property (weak,    atomic) id<RICreateReminderDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, atomic) NSMutableArray<UIImage *> *arrayOfImages;

@property (assign, atomic) BOOL showsAlertOnCancel;

- (void)cancelReminderCreationShowingAlert:(BOOL)showsAlert;

+ (UINavigationController *)instanceWithCompletionHandler:(void (^)(RIResponse *, __weak UIViewController *))completionHandler;

@end
