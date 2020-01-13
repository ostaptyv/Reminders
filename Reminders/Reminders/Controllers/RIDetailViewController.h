//
//  RIDetailViewController.h
//  Reminders
//
//  Created by Ostap on 24.11.2019.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RIReminder.h"

NS_ASSUME_NONNULL_BEGIN

@interface RIDetailViewController : UIViewController <UINavigationControllerDelegate, UICollectionViewDataSource>

@property (readwrite, nonatomic) RIReminder *reminder;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

+ (RIDetailViewController *)instanceWithReminder:(RIReminder *)reminder;

@end

NS_ASSUME_NONNULL_END
