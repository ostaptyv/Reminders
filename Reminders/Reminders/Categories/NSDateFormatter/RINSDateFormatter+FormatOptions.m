//
//  RINSDateFormatter+FormatOptions.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/11/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RINSDateFormatter+FormatOptions.h"

@implementation NSDateFormatter (FormatOptions)

+ (NSDateFormatter *)releaseDateFormatter {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    dateFormatter.dateFormat = @"dd.MM.yyyy, HH:mm";
    
    return dateFormatter;
}

@end
