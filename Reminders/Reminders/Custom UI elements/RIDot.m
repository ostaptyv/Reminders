//
//  RIDot.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/19/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "RIDot.h"
#import "RIConstants.h"

//PRIVATE CONSTANTS:
static void *RIDotDotBorderWidthContext = &RIDotDotBorderWidthContext;
static void *RIDotDotColorContext = &RIDotDotColorContext;
static void *RIDotIsOnContext = &RIDotIsOnContext;

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

#pragma mark Setting default property values

- (void)setDefaultValues {
    self.isOn = NO;
    
    self.dotBorderWidth = defaultDotBorderWidth;
    self.dotColor = [UIColor defaultDotColor];
}

#pragma mark Setup adding and removing KVO-observer

- (void)registerObservers {
    [self addObserver:self
           forKeyPath:@"dotBorderWidth"
              options:NSKeyValueObservingOptionNew
              context:RIDotDotBorderWidthContext];
    
    [self addObserver:self
           forKeyPath:@"dotColor"
              options:NSKeyValueObservingOptionNew
              context:RIDotDotColorContext];
    
    [self addObserver:self
           forKeyPath:@"isOn"
              options:NSKeyValueObservingOptionNew
              context:RIDotIsOnContext];
}

- (void)unregisterObservers {
    [self removeObserver:self
              forKeyPath:@"dotBorderWidth"
                 context:RIDotDotBorderWidthContext];
    
    [self removeObserver:self
              forKeyPath:@"dotColor"
                 context:RIDotDotColorContext];
    
    [self removeObserver:self
              forKeyPath:@"isOn"
                 context:RIDotIsOnContext];
}

#pragma mark Managing KVO property changes

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == RIDotDotBorderWidthContext) {
        CGFloat dotBorderWidth;
        
        [(NSValue *)change[NSKeyValueChangeNewKey] getValue:&dotBorderWidth];
        
        self.layer.borderWidth = dotBorderWidth;
        return;
    }
                
    if (context == RIDotDotColorContext) {
        UIColor *dotColor = change[NSKeyValueChangeNewKey];
        
        self.layer.borderColor = [dotColor CGColor];
        return;
    }
                    
    if (context == RIDotIsOnContext) {
        BOOL isOn;
        
        [(NSValue *)change[NSKeyValueChangeNewKey] getValue:&isOn];
        
        [self setupDotWithState:isOn];
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }

#pragma mark Main RIDot behavior method

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
        [self registerObservers];
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setDefaultValues];
        [self registerObservers];
    }
    
    return self;
}

#pragma mark Dealloc

- (void)dealloc {
    [self unregisterObservers];
}

@end

