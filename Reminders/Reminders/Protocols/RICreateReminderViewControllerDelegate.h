//
//  RICreateReminderViewControllerDelegate.h
//  Reminders
//
//  Created by Ostap on 24.11.2019.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIReminder.h"

@protocol RICreateReminderViewControllerDelegate <NSObject>

@optional
- (void)didCreateReminder:(RIReminder *)newReminder;

@end
