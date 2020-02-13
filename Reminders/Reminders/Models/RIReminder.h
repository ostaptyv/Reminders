//
//  RIReminder.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/22/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RIReminder : NSObject <NSCopying>

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSMutableArray<UIImage *> *arrayOfImages;

@property (strong, nonatomic) NSMutableArray<NSURL *> *arrayOfImageURLs;

- (instancetype)initWithText:(NSString *)text dateString:(NSString *)date arrayOfImageURLs:(NSMutableArray<NSURL *> *)arrayOfImageURLs;
- (instancetype)initWithText:(NSString *)text dateString:(NSString *)date arrayOfImages:(NSMutableArray<UIImage *> *)arrayOfImages;
- (instancetype)initWithText:(NSString *)text dateInstance:(NSDate *)date arrayOfImages:(NSMutableArray<UIImage *> *)arrayOfImages;

- (id)copyWithZone:(nullable NSZone *)zone;
- (id)copy;

@end

NS_ASSUME_NONNULL_END
