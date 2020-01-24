//
//  RIReminder.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/22/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RIReminder : NSObject <NSCopying>

@property (strong, atomic, nonnull) NSString *text;
@property (strong, atomic, nonnull) NSString *date;
@property (strong, atomic, nonnull) NSMutableArray<UIImage *> *arrayOfImages;

@property (strong, atomic, nonnull) NSMutableArray<NSURL *> *arrayOfImageURLs;

- (nonnull instancetype)initWithText:(nonnull NSString *)text dateString:(nonnull NSString *)date arrayOfImageURLs:(nonnull NSMutableArray<NSURL *> *)arrayOfImageURLs;
- (nonnull instancetype)initWithText:(nonnull NSString *)text dateString:(nonnull NSString *)date arrayOfImages:(nonnull NSMutableArray<UIImage *> *)arrayOfImages;
- (nonnull instancetype)initWithText:(nonnull NSString *)text dateInstance:(nonnull NSDate *)date arrayOfImages:(nonnull NSMutableArray<UIImage *> *)arrayOfImages;

- (nonnull id)copyWithZone:(nullable NSZone *)zone;
- (nonnull id)copy;

@end

