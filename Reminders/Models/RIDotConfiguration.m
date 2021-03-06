//
//  RIDotConfiguration.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/30/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RIDotConfiguration.h"
#import "RIConstants.h"
#import "RIUIColor+Constants.h"

@implementation RIDotConfiguration

#pragma mark - Default configuration instance (singletone)

+ (RIDotConfiguration *)defaultConfiguration {
    static RIDotConfiguration *_defaultConfiguration;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _defaultConfiguration = [[RIDotConfiguration alloc] initWithOffAnimationDuration:kDefaultOffAnimationDuration dotBorderWidth:kDefaultDotBorderWidth dotColor:UIColor.defaultDotColor];
    });
    
    return _defaultConfiguration;
}

#pragma mark - Initializers

- (instancetype)initWithOffAnimationDuration:(CGFloat)offAnimationDuration dotBorderWidth:(CGFloat)dotBorderWidth dotBorderColor:(UIColor *)dotBorderColor dotFillColor:(UIColor *)dotFillColor {
    self = [super init];
    
    if (self) {
        self.offAnimationDuration = offAnimationDuration;
        self.dotBorderWidth = dotBorderWidth;
        self.dotBorderColor = dotBorderColor;
        self.dotFillColor = dotFillColor;
    }
    
    return self;
}

- (instancetype)initWithOffAnimationDuration:(CGFloat)offAnimationDuration dotBorderWidth:(CGFloat)dotBorderWidth dotColor:(UIColor *)dotColor {
    return [self initWithOffAnimationDuration:offAnimationDuration dotBorderWidth:dotBorderWidth dotBorderColor:dotColor dotFillColor:dotColor];
}

@end
