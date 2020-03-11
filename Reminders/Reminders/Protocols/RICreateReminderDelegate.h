//
//  RICreateReminderDelegate.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/16/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RIReminder.h"
#import "RIResponse.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RICreateReminderDelegate <NSObject>

@optional
- (void)didCreateReminderWithResponse:(RIResponse *)response shouldDismiss:(BOOL *)shouldDismiss;
- (void)didPressAlertProceedButton:(BOOL *)shouldDismiss;
- (void)didPressAlertCancelButton:(BOOL *)shouldDismiss;

@end

NS_ASSUME_NONNULL_END
