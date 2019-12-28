//
//  RIDot.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/19/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE @interface RIDot : UIView

@property (nonatomic) IBInspectable CGFloat dotBorderWidth;
@property (nonatomic) IBInspectable UIColor *dotColor;
@property (nonatomic) IBInspectable BOOL isOn;

- (instancetype)initWithState:(BOOL)isOn;
- (instancetype)initWithState:(BOOL)isOn dotBorderWidth:(CGFloat)dotBorderWidth dotColor:(UIColor *)dotColor;

@end
