//
//  RISetNewPasscodeStrategy.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/31/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RIPasscodeStrategy.h"
#import "RIPasscodeStrategySubclass.h"
#import "RIPasscodeEntryState.h"
#import "RIConstants.h"

@implementation RIPasscodeStrategy

#pragma mark - Property setters

- (void)setPasscodeCounter:(NSUInteger)passcodeCounter {
    if (passcodeCounter < 0 || passcodeCounter > self.passcodeEntryView.dotsControl.dotsCount) {
        return;
    }
    
    _passcodeCounter = passcodeCounter;
}

#pragma mark - Execute method

- (void)execute {
    [self setupStrategy];
    self.enteredPasscode = [NSMutableString new];
}

#pragma mark - Setup strategy

- (void)setupStrategy {
    // Must be overriden by subclass
}

#pragma mark - UIKeyInput implementation

- (void)insertText:(NSString *)text {
    if (self.editingDisabled) {
        return;
    }
    
    if (self.successfulResponseSent) {
        [self.passcodeEntryView.dotsControl recolorDotsTo:self.passcodeEntryView.dotsControl.dotsCount];
        return;
    }
    
    [self.enteredPasscode appendString:text];

    [self.passcodeEntryView.dotsControl recolorDotsTo: ++self.passcodeCounter completionHandler:^(BOOL finished) {
        
        if (self.passcodeCounter != self.passcodeEntryView.dotsControl.dotsCount) {
            return;
        }
        
        [self handleEntryWithState:self.state];
    }];
}

- (void)deleteBackward {
    if (self.editingDisabled) {
        return;
    }
    
    if (self.successfulResponseSent) {
        [self.passcodeEntryView.dotsControl recolorDotsTo:self.passcodeEntryView.dotsControl.dotsCount];
        return;
    }
    
    [self.passcodeEntryView.dotsControl recolorDotsTo: --self.passcodeCounter];
    
    if (self.enteredPasscode.length == 0) {
        return;
    }
    
    [self.enteredPasscode deleteCharactersInRange:NSMakeRange(self.enteredPasscode.length - 1, 1)];
}

#pragma mark - Clean input and revert state methods

- (void)cleanInput {
    self.enteredPasscode = [NSMutableString string];
    
    self.passcodeCounter = 0;
    [self.passcodeEntryView.dotsControl recolorDotsTo:0];
}

- (void)revertState {
    // Must be overriden by subclass
}

#pragma mark - Handle entry with state

- (void)handleEntryWithState:(RIPasscodeEntryState)state {
    // Must be overriden by subclass
}

#pragma mark - Animation transitions managing

- (void)performSwipeAnimationForSubtype:(CATransitionSubtype)subtype {
    CATransition *swipeTransition = [CATransition new];
    
    swipeTransition.type = kCATransitionPush;
    swipeTransition.subtype = subtype;
    swipeTransition.duration = 0.25;
    swipeTransition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    swipeTransition.fillMode = kCAFillModeRemoved;
    
    [self.passcodeEntryView.layer addAnimation:swipeTransition forKey:@"swipeTransition"];
}

#pragma mark - Initializers

- (instancetype)initWithPasscodeEntryView:(RIPasscodeEntryView *)passcodeEntryView responseBlock:(void (^)(RIResponse *))responseBlock {
    self = [super init];
    
    if (self) {
        self.passcodeEntryView = passcodeEntryView;
        self.responseBlock = responseBlock;
    }
    
    return self;
}

#pragma mark - Dealloc method

- (void)dealloc {
    self.enteredPasscode = nil;
}

@end
