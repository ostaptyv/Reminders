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

@interface RIDetailViewController : UIViewController

@property (nonatomic) RIReminder *reminder;

@property (weak, nonatomic) IBOutlet UITextView *textView;

+ (RIDetailViewController *)instanceWithReminder:(RIReminder *)reminder;

@end

NS_ASSUME_NONNULL_END
