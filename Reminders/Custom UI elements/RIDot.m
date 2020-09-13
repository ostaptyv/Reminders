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
static void *RIDotDotConfigurationContext = &RIDotDotConfigurationContext;
static void *RIDotIsOnContext = &RIDotIsOnContext;

static NSString* const kDotConfigurationKeyPath = @"dotConfiguration";
static NSString* const kIsOnKeyPath = @"isOn";

@interface RIDot ()

@end

@implementation RIDot

#pragma mark - Property setters

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

#pragma mark - Setting default property values

- (void)setDefaultPropertyValues {
    self.isOn = NO;
    
    self.dotConfiguration = RIDotConfiguration.defaultConfiguration;
}

#pragma mark - Setup adding and removing KVO-observer

- (void)registerObservers {
    [self addObserver:self
           forKeyPath:kDotConfigurationKeyPath
              options:NSKeyValueObservingOptionNew
              context:RIDotDotConfigurationContext];
    
    [self addObserver:self
           forKeyPath:kIsOnKeyPath
              options:NSKeyValueObservingOptionNew
              context:RIDotIsOnContext];
}

- (void)unregisterObservers {
    [self removeObserver:self
              forKeyPath:kDotConfigurationKeyPath
                 context:RIDotDotConfigurationContext];
    
    [self removeObserver:self
              forKeyPath:kIsOnKeyPath
                 context:RIDotIsOnContext];
}

#pragma mark - Managing KVO property changes

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == RIDotDotConfigurationContext) {
        RIDotConfiguration *dotConfiguration = change[NSKeyValueChangeNewKey];
        
        [self applyDotConfiguration:dotConfiguration];
        return;
    }
                    
    if (context == RIDotIsOnContext) {
        BOOL isOn;
        NSValue *newValue = change[NSKeyValueChangeNewKey];
        
        [newValue getValue:&isOn];
        
        [self setupDotWithState:isOn];
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - Apply dot configuration

- (void)applyDotConfiguration:(RIDotConfiguration *)dotConfiguration {
    [self updateDotColorsWithConfiguration:dotConfiguration];
}

#pragma mark - Update dot colors

- (void)updateDotColorsWithConfiguration:(RIDotConfiguration *)dotConfiguration {
    self.layer.borderColor = [dotConfiguration.dotBorderColor CGColor];
    self.layer.borderWidth = dotConfiguration.dotBorderWidth;
    
    if (self.isOn) {
        self.layer.backgroundColor = [dotConfiguration.dotFillColor CGColor];
    }
}

#pragma mark - Main RIDot behavior method

- (void)setupDotWithState:(BOOL)isOn {
    if (isOn) {
        [UIView animateWithDuration:0.0 animations:^{
            
            self.layer.backgroundColor = [self.dotConfiguration.dotFillColor CGColor];
            
        } completion:self.completionHandler];
    } else {
        [UIView animateWithDuration:self.dotConfiguration.offAnimationDuration animations:^{
            
            self.layer.backgroundColor = [[UIColor clearColor] CGColor];
            
        } completion:self.completionHandler];
    }
}

#pragma mark - Corresponding to trait collection change

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    [self updateDotColorsWithConfiguration:self.dotConfiguration];
    [self setNeedsDisplay];
}

#pragma mark - Custom init-s

- (instancetype)initWithState:(BOOL)isOn dotConfiguration:(RIDotConfiguration *)dotConfiguration {
    self = [super init];
    
    if (self) {
        [self setDefaultPropertyValues];
        
        self.isOn = isOn;
        self.dotConfiguration = dotConfiguration;
        
        [self setupDotWithState:isOn];
    }
    
    return self;
}

- (instancetype)initWithState:(BOOL)isOn {
    return [self initWithState:isOn dotConfiguration:RIDotConfiguration.defaultConfiguration];
}

#pragma mark - Default overriden init-s

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setDefaultPropertyValues];
        [self registerObservers];
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setDefaultPropertyValues];
        [self registerObservers];
    }
    
    return self;
}

#pragma mark - Dealloc method

- (void)dealloc {
    [self unregisterObservers];
}

@end

