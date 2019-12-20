//
//  UIDot.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/19/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "UIDot.h"

@interface UIDot ()

@end

@implementation UIDot

- (void)viewDidLoad {
    [self setupPropertyValues];
}

- (void)setIsOn:(BOOL)isOn {
    _isOn = isOn;
    
    [self setupDotWithState:isOn];
}

- (void)setDotColor:(UIColor *)dotColor {
    _dotColor = dotColor;
    
    [self setupPropertyValues];
}

- (void)setDotBorderWidth:(CGFloat)dotBorderWidth {
    _dotBorderWidth = dotBorderWidth;
    
    [self setupPropertyValues];
}
- (void)setupDotWithState:(BOOL)isOn {
    if (isOn) {
        self.layer.backgroundColor = [self.dotColor CGColor];
    } else {
        [UIView animateWithDuration:0.35 animations:^{
            self.layer.backgroundColor = [[UIColor clearColor] CGColor];
        }];
    }
}

- (void)setupPropertyValues {
    CGRect bounds = self.bounds;
    float minimum = MIN(bounds.size.height, bounds.size.width);
    
    self.bounds = CGRectMake(0, 0, minimum, minimum);
    self.layer.cornerRadius = minimum / 2;
    
    self.layer.borderWidth = self.dotBorderWidth;
    self.layer.borderColor = [self.dotColor CGColor];
}

- (void)setupDefaultValues {
    self.isOn = NO;
    
    self.dotBorderWidth = 2;
    self.dotColor = [UIColor blackColor];
}

- (instancetype)initWithState:(BOOL)isOn dotBorderWidth:(CGFloat)dotBorderWidth dotColor:(UIColor *)dotColor {
    self = [super init];
    
    if (self) {
        [self setupDefaultValues];
        
        self.isOn = isOn;
        [self setupDotWithState:isOn];
        
        self.dotBorderWidth = dotBorderWidth;
        self.dotColor = dotColor;
        
        [self viewDidLoad];
    }
    
    return self;
}

- (instancetype)initWithState:(BOOL)isOn {
    return [self initWithState:isOn dotBorderWidth:2 dotColor:[UIColor blackColor]];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupDefaultValues];
        
        [self viewDidLoad];
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setupDefaultValues];
        
        [self viewDidLoad];
    }
    
    return self;
}

@end
