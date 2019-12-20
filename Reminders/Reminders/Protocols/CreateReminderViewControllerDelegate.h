//
//  CreateReminderViewControllerDelegate.h
//  Reminders
//
//  Created by Ostap on 24.11.2019.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reminder.h"

@protocol CreateReminderViewControllerDelegate <NSObject>

@optional
- (void)didCreateReminder:(Reminder *)newReminder;

@end
