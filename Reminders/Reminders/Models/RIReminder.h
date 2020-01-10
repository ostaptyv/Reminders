//
//  RIReminder.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/22/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RIReminder : NSObject

@property NSString *text;
@property NSString *date;
@property NSMutableArray<UIImage *> *arrayOfImages;

- (instancetype)initWithText:(NSString *)text dateString:(NSString *)date arrayOfImages:(NSMutableArray<UIImage *> *)arrayOfImages;
- (instancetype)initWithText:(NSString *)text dateInstance:(NSDate *)date arrayOfImages:(NSMutableArray<UIImage *> *)arrayOfImages;


@end

