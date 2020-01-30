//
//  RIDot.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/19/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RIDotConfiguration.h"

IB_DESIGNABLE @interface RIDot : UIView

@property (strong, atomic) IBInspectable RIDotConfiguration *dotConfiguration;

@property (assign, atomic) IBInspectable BOOL isOn;

- (instancetype)initWithState:(BOOL)isOn;
- (instancetype)initWithState:(BOOL)isOn dotConfiguration:(RIDotConfiguration *)dotConfiguration;

@end
