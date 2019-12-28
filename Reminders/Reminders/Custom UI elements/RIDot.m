//
//  RIDot.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/19/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "RIDot.h"
#import "RIConstants.h"

@interface RIDot ()

@end

@implementation RIDot

#pragma mark Property setters

- (void)setBounds:(CGRect)bounds {
    float minimum = MIN(bounds.size.height, bounds.size.width);
    
    [super setBounds:CGRectMake(bounds.origin.x, bounds.origin.y, minimum, minimum)];
    
    self.layer.cornerRadius = minimum / 2;
}

- (void)setFrame:(CGRect)frame {
    float minimum = MIN(frame.size.height, frame.size.width);
    
    [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, minimum, minimum)];
    
    self.layer.cornerRadius = minimum / 2;
}

- (void)setDotBorderWidth:(CGFloat)dotBorderWidth {
    _dotBorderWidth = fabs(dotBorderWidth);
    
    self.layer.borderWidth = dotBorderWidth;
}

- (void)setDotColor:(UIColor *)dotColor {
    _dotColor = dotColor;
    
    self.layer.borderColor = [dotColor CGColor];
}

- (void)setIsOn:(BOOL)isOn {
    _isOn = isOn;
    
    [self setupDotWithState:isOn];
}

#pragma mark Setting default property values

- (void)setDefaultValues {
    self.isOn = NO;
    
    self.dotBorderWidth = defaultDotBorderWidth;
    self.dotColor = [UIColor defaultDotColor];
}

#pragma mark Main UIDot behavior method

- (void)setupDotWithState:(BOOL)isOn {
    if (isOn) {
        self.layer.backgroundColor = [self.dotColor CGColor];
    } else {
        [UIView animateWithDuration:animationDuration animations:^{
            self.layer.backgroundColor = [[UIColor clearColor] CGColor];
        }];
    }
}

#pragma mark Custom init-s

- (instancetype)initWithState:(BOOL)isOn dotBorderWidth:(CGFloat)dotBorderWidth dotColor:(UIColor *)dotColor {
    self = [super init];
    
    if (self) {
        [self setDefaultValues];
        
        self.isOn = isOn;
        self.dotBorderWidth = fabs(dotBorderWidth);
        self.dotColor = dotColor;
        
        [self setupDotWithState:isOn];
    }
    
    return self;
}

- (instancetype)initWithState:(BOOL)isOn {
    return [self initWithState:isOn dotBorderWidth:defaultDotBorderWidth dotColor:[UIColor defaultDotColor]];
}

#pragma mark Default overriden init-s

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setDefaultValues];
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setDefaultValues];
    }
    
    return self;
}

@end

