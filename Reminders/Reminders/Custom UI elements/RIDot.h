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

@property (strong, nonatomic) IBInspectable RIDotConfiguration *dotConfiguration;

@property (assign, nonatomic) IBInspectable BOOL isOn;
@property (strong, nonatomic) void (^completionHandler)(BOOL);

- (instancetype)initWithState:(BOOL)isOn;
- (instancetype)initWithState:(BOOL)isOn dotConfiguration:(RIDotConfiguration *)dotConfiguration;

@end
