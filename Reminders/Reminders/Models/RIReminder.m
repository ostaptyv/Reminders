//
//  RIReminder.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/22/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIReminder.h"
#import "RINSDateFormatter+FormatOptions.h"

@implementation RIReminder

+ (NSString *)entityName {
    return NSStringFromClass(RIReminder.class);
}

- (RIReminderRaw *)transformToRaw {
    return [[RIReminderRaw alloc] initWithText:self.text dateString:self.date arrayOfImages:[NSMutableArray new]]; // temporarily passing empty array until implementing image loading infrastructure
}

@end
