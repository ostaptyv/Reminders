//
//  DetailViewController.h
//  Reminders
//
//  Created by Ostap on 24.11.2019.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reminder.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController

@property (nonatomic) Reminder *reminder;

@property (weak, nonatomic) IBOutlet UITextView *textView;

+ (DetailViewController *)instanceWithReminder:(Reminder *)reminder;

@end

NS_ASSUME_NONNULL_END
