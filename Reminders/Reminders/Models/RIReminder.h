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

@property NSString * __nonnull text;
@property NSString * __nonnull date;
@property NSMutableArray<UIImage *> * __nonnull arrayOfImages;

- (nonnull instancetype)initWithText:(NSString * __nonnull)text dateString:(NSString * __nonnull)date arrayOfImages:(NSMutableArray<UIImage *> * __nonnull)arrayOfImages;
- (nonnull instancetype)initWithText:(NSString * __nonnull)text dateInstance:(NSDate * __nonnull)date arrayOfImages:(NSMutableArray<UIImage *> * __nonnull)arrayOfImages;

- (nonnull id)copyWithZone:(nullable NSZone *)zone;
- (nonnull id)copy;

@end

