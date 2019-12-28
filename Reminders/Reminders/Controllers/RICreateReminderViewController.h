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

NS_ASSUME_NONNULL_BEGIN

@interface RICreateReminderViewController : UIViewController

@property (weak) id <RICreateReminderViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;

+ (RICreateReminderViewController *)instance;

@end

NS_ASSUME_NONNULL_END
