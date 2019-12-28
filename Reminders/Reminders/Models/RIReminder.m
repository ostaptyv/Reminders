//
//  RIReminder.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/22/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIReminder.h"

@implementation RIReminder

- (id)initWithText:(NSString *)text dateString:(NSString *)date {
    if (self = [super init]) {
        self.text = text;
        self.date = date;
    }
    
    return self;
}

- (id)initWithText:(NSString *)text dateInstance:(NSDate *)date {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    dateFormatter.dateFormat = @"dd.MM.yyyy, HH:mm";
    
    return [self initWithText:text dateString:[dateFormatter stringFromDate:date]];
}

+ (id)reminderWithText:(NSString *)text dateString:(NSString *)date {
    return [[RIReminder alloc] initWithText:text dateString:date];
}

+ (id)reminderWithText:(NSString *)text dateInstance:(NSDate *)date {
    return [[RIReminder alloc] initWithText:text dateInstance:date];
}

@end
