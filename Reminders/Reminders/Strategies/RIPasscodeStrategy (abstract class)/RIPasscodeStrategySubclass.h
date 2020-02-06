//
//  RIPasscodeStrategySubclass.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/3/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RIPasscodeStrategy.h"
#import "RIPasscodeEntryState.h"

@interface RIPasscodeStrategy ()

@property (weak,   atomic) RIPasscodeEntryView *passcodeEntryView;
@property (strong, atomic) void (^responseBlock)(RIResponse *);

@property (strong,    atomic) NSMutableString *enteredPasscode;
@property (assign, nonatomic) NSUInteger passcodeCounter;

@property (assign, atomic) BOOL successfulResponseSent;

@property (assign, atomic) RIPasscodeEntryState state;

// Methods to be overriden by subclass:
- (void)setupStrategy;
- (void)handleEntryWithState:(RIPasscodeEntryState)state;

- (void)performSwipeAnimationForSubtype:(CATransitionSubtype)subtype;

@end
