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
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    dateFormatter.dateFormat = @"dd.MM.yyyy, HH:mm";
    
    return [self initWithText:text dateString:[dateFormatter stringFromDate:date] arrayOfImages:arrayOfImages];
}

@end
