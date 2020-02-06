//
//  RIDotConfiguration.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/30/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RIDotConfiguration.h"
#import "RIConstants.h"

@implementation RIDotConfiguration

#pragma mark +defaultConfiguration

+ (RIDotConfiguration *)defaultConfiguration {
    static RIDotConfiguration *_defaultConfiguration;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _defaultConfiguration = [[RIDotConfiguration alloc] initWithOffAnimationDuration:kOffAnimationDuration dotBorderWidth:kDefaultDotBorderWidth dotColor:UIColor.kDefaultDotColor];
    });
    
    return _defaultConfiguration;
}

#pragma mark NSCopying implementation

- (id)copyWithZone:(NSZone *)zone {
    UIColor *dotBorderColor = [self.dotBorderColor copy];
    UIColor *dotFillColor = [self.dotFillColor copy];
    
    return [[RIDotConfiguration alloc] initWithOffAnimationDuration:self.offAnimationDuration dotBorderWidth:self.dotBorderWidth dotBorderColor:dotBorderColor dotFillColor:dotFillColor];
}

- (id)copy {
    return [self copyWithZone:nil];
}

#pragma mark Initializers

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
