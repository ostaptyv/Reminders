//
//  UIDot.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/19/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDot : UIView

@property (nonatomic) CGFloat dotBorderWidth;
@property (nonatomic) UIColor *dotColor;

@property (nonatomic) BOOL isOn;

- (instancetype)initWithState:(BOOL)isOn;
- (instancetype)initWithState:(BOOL)isOn dotBorderWidth:(CGFloat)dotBorderWidth dotColor:(UIColor *)dotColor;

@end
