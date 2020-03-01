//
//  RINumberPadButton.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/23/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "RINumberPadButton.h"
#import "RIAccessibilityConstants.h"

//PRIVATE CONSTANTS:
static void *RINumberPadButtonButtonTagContext = &RINumberPadButtonButtonTagContext;

static NSString* const kButtonTagKeyPath = @"buttonTag";

@implementation RINumberPadButton

#pragma mark - Setup adding and removing KVO-observer

- (void)registerObservers {
    [self addObserver:self
           forKeyPath:kButtonTagKeyPath
              options:NSKeyValueObservingOptionNew
              context:RINumberPadButtonButtonTagContext];
}

- (void)unregisterObservers {
    [self removeObserver:self
              forKeyPath:kButtonTagKeyPath
                 context:RINumberPadButtonButtonTagContext];
}

#pragma mark - Managing KVO property changes

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == RINumberPadButtonButtonTagContext) {
        NSUInteger buttonTag;
        NSValue *newValue = change[NSKeyValueChangeNewKey];
        
        [newValue getValue:&buttonTag];
        
        switch (buttonTag) {
            case RINumberPadButtonTagBiometry:
                self.accessibilityIdentifier = kNumberPadButtonBiometryIdentifier;
                break;
                
            default:
                break;
        }
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - Initializers

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        [self registerObservers];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self registerObservers];
    }
    
    return self;
}

#pragma mark - Dealloc method

- (void)dealloc {
    [self unregisterObservers];
}

@end
