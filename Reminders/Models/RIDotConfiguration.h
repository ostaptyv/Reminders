//
//  RIDotConfiguration.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/30/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE @interface RIDotConfiguration : NSObject <NSCopying>

@property (assign, nonatomic) IBInspectable CGFloat offAnimationDuration;
@property (assign, nonatomic) IBInspectable CGFloat dotBorderWidth;
@property (strong, nonatomic) IBInspectable UIColor *dotBorderColor;
@property (strong, nonatomic) IBInspectable UIColor *dotFillColor;

@property (strong, nonatomic, class, readonly) RIDotConfiguration *defaultConfiguration;

- (id)copyWithZone:(NSZone *)zone;
- (id)copy;

- (instancetype)initWithOffAnimationDuration:(CGFloat)offAnimationDuration dotBorderWidth:(CGFloat)dotBorderWidth dotBorderColor:(UIColor *)dotBorderColor dotFillColor:(UIColor *)dotFillColor;
- (instancetype)initWithOffAnimationDuration:(CGFloat)offAnimationDuration dotBorderWidth:(CGFloat)dotBorderWidth dotColor:(UIColor *)dotColor;

@end