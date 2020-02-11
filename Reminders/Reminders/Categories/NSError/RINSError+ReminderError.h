//
//  RINSError+ReminderError.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/3/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIError.h"
#import "RISecureManagerError.h"

@interface NSError (ReminderError)

// you actually pass the RIError and RISecureManagerError codes here (which RIError and RISecureManager enums itself are)
+ (NSError *)generateReminderError:(RIError)errorCode;
+ (NSError *)generateSecureManagerError:(RISecureManagerError)errorCode;

@end
