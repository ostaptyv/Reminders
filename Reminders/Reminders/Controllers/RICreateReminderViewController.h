//
//  RICreateReminderViewController.h
//  Reminders
//
//  Created by Ostap on 24.11.2019.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RICreateReminderViewController.h"
#import "RICreateReminderViewControllerDelegate.h"
#import "RIReminder.h"

@interface RICreateReminderViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UITextViewDelegate, UICollectionViewDataSource>

@property (weak) id<RICreateReminderViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

+ (UINavigationController *)instance;

@end
