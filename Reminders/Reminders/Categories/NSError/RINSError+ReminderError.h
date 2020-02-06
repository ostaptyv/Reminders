//
//  RINSError+ReminderError.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/3/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIError.h"

@interface NSError (ReminderError)

+ (NSError *)generateReminderError:(RIError)error;

@end
