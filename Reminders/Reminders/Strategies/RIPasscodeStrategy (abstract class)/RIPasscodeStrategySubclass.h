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

@property (weak, nonatomic) RIPasscodeEntryView *passcodeEntryView;
@property (strong, nonatomic) void (^responseBlock)(RIResponse *);

@property (strong, nonatomic) NSMutableString *enteredPasscode;
@property (assign, nonatomic) NSUInteger passcodeCounter;

@property (assign, nonatomic) BOOL successfulResponseSent;

@property (assign, nonatomic) RIPasscodeEntryState state;

// 2 methods to be overriden by the subclass:
- (void)setupStrategy;
- (void)handleEntryWithState:(RIPasscodeEntryState)state;

- (void)performSwipeAnimationForSubtype:(CATransitionSubtype)subtype;

@end
