//
//  RICreateReminderDelegate.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/16/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RIReminder.h"
#import "RIResponse.h"

@protocol RICreateReminderDelegate <NSObject>

@optional
- (void)didCreateReminderWithResponse:(nonnull RIResponse *)response viewController:(nullable UIViewController *)viewController;
- (void)didPressAlertProceedButtonOnParent:(nullable UIViewController *)parentViewController;
- (void)didPressAlertCancelButton;

@end
