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
#import "RICacheManager.h"
#import "RINSFileManager+ImageSaving.h"

@implementation RIReminder

+ (NSString *)entityName {
    return NSStringFromClass(RIReminder.class);
}

- (RIReminderRaw *)transformToRaw {
    NSMutableArray<UIImage *> *arrayOfImages = [NSMutableArray new];
    
    for (NSString *path in self.arrayOfImagePaths) {
        NSURL *imageURL = [[NSFileManager.defaultManager documentsURL] URLByAppendingPathComponent:path];
        UIImage *image = [RICacheManager.sharedInstance imageByURL:imageURL];
        [arrayOfImages addObject:image];
    }
    
    return [[RIReminderRaw alloc] initWithText:self.text dateString:self.date arrayOfImages:[arrayOfImages copy]];
}

@end
