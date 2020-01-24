//
//  RIDot.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/19/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE @interface RIDot : UIView

@property (assign, atomic) IBInspectable CGFloat dotBorderWidth;
@property (assign, atomic) IBInspectable UIColor *dotColor;
@property (assign, atomic) IBInspectable BOOL isOn;

- (instancetype)initWithState:(BOOL)isOn;
- (instancetype)initWithState:(BOOL)isOn dotBorderWidth:(CGFloat)dotBorderWidth dotColor:(UIColor *)dotColor;

@end
