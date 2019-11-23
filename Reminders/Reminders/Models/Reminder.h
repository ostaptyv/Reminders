//
//  Reminder.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/22/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reminder : NSObject

@property (atomic) NSString *text;
@property (nonatomic) NSString *date;

- (id)initWithText:(NSString *)text dateString:(NSString *)date;
- (id)initWithText:(NSString *)text dateInstance:(NSDate *)date;

+ (id)reminderWithText:(NSString *)text dateString:(NSString *)date;
+ (id)reminderWithText:(NSString *)text dateInstance:(NSDate *)date;

@end

