//
//  RICreateReminderHandlerService.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 3/10/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIReminderRaw.h"
#import "RICreateReminderDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface RICreateReminderHandlerService : NSObject <RICreateReminderDelegate>

- (void)manageViewControllersShowingBehavior;

- (instancetype)initWithRawReminder:(RIReminderRaw *)rawReminder;

@end

NS_ASSUME_NONNULL_END
