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

- (instancetype)initWithText:(NSString *)text dateString:(NSString *)date arrayOfImageURLs:(NSMutableArray<NSURL *> *)arrayOfImageURLs {
    self = [super init];
    
    if (self) {
        self.text = text;
        self.date = date;
        self.arrayOfImages = [NSMutableArray new];
        
        self.arrayOfImageURLs = arrayOfImageURLs;
    }
    
    return self;
}

- (instancetype)initWithText:(NSString *)text dateString:(NSString *)date arrayOfImages:(NSMutableArray<UIImage *> *)arrayOfImages {
    self = [super init];
    
    if (self) {
        self.text = text;
        self.date = date;
        self.arrayOfImages = arrayOfImages;
        
        self.arrayOfImageURLs = [NSMutableArray new];
    }
    
    return self;
}

- (instancetype)initWithText:(NSString *)text dateInstance:(NSDate *)date arrayOfImages:(NSMutableArray<UIImage *> *)arrayOfImages{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    dateFormatter.dateFormat = @"dd.MM.yyyy, HH:mm";
    
    return [self initWithText:text dateString:[dateFormatter stringFromDate:date] arrayOfImages:arrayOfImages];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    NSString *text = [self.text copy];
    NSString *date = [self.date copy];
    NSMutableArray<UIImage *> *arrayOfImages = [self.arrayOfImages mutableCopy];
    
    RIReminder *copiedReminder = [[RIReminder alloc] initWithText:text
                                                       dateString:date
                                                    arrayOfImages:arrayOfImages];
    
    return copiedReminder;
}

- (nonnull id)copy {
    return [self copyWithZone:nil];
}

@end
