//
//  RIReminderRaw.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/28/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RIReminderRaw.h"
#import "RINSDateFormatter+FormatOptions.h"

@implementation RIReminderRaw

#pragma mark - NSCopying implementation

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    NSString *text = [self.text copy];
    NSString *date = [self.date copy];
    NSMutableArray<UIImage *> *arrayOfImages = [self.arrayOfImages mutableCopy];

    RIReminderRaw *copiedReminder = [[RIReminderRaw alloc] initWithText:text dateString:date arrayOfImages:arrayOfImages];

    return copiedReminder;
}

- (nonnull id)copy {
    return [self copyWithZone:nil];
}

#pragma mark Initializers

- (instancetype)initWithText:(NSString *)text dateString:(NSString *)date arrayOfImages:(NSMutableArray<UIImage *> *)arrayOfImages {
    self = [super init];
    
    if (self) {
        self.text = text;
        self.date = date;
        self.arrayOfImages = arrayOfImages;
    }
    
    return self;
}

- (instancetype)initWithText:(NSString *)text dateInstance:(NSDate *)date arrayOfImages:(NSMutableArray<UIImage *> *)arrayOfImages{
    return [self initWithText:text dateString:[NSDateFormatter.releaseDateFormatter stringFromDate:date] arrayOfImages:arrayOfImages];
}

@end
