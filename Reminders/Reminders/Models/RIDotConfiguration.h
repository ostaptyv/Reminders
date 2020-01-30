//
//  RIDotConfiguration.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/30/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE @interface RIDotConfiguration : NSObject

@property (assign, atomic) IBInspectable CGFloat offAnimationDuration;
@property (assign, atomic) IBInspectable CGFloat dotBorderWidth;
@property (strong, atomic) IBInspectable UIColor *dotBorderColor;
@property (strong, atomic) IBInspectable UIColor *dotFillColor;

@property (strong, nonatomic, class, readonly) RIDotConfiguration *defaultConfiguration;

- (instancetype)initWithOffAnimationDuration:(CGFloat)offAnimationDuration dotBorderWidth:(CGFloat)dotBorderWidth dotBorderColor:(UIColor *)dotBorderColor dotFillColor:(UIColor *)dotFillColor;
- (instancetype)initWithOffAnimationDuration:(CGFloat)offAnimationDuration dotBorderWidth:(CGFloat)dotBorderWidth dotColor:(UIColor *)dotColor;

@end
