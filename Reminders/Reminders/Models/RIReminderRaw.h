//
//  RIReminderRaw.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/28/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RIReminderRaw : NSObject <NSCopying>

@property (nullable, nonatomic, retain) NSArray<UIImage *> *arrayOfImages;
@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSString *text;

- (instancetype)initWithText:(NSString *)text dateString:(NSString *)date arrayOfImages:(NSMutableArray<UIImage *> *)arrayOfImages;
- (instancetype)initWithText:(NSString *)text dateInstance:(NSDate *)date arrayOfImages:(NSMutableArray<UIImage *> *)arrayOfImages;

- (id)copyWithZone:(nullable NSZone *)zone;
- (id)copy;

@end

NS_ASSUME_NONNULL_END
