//
//  RISetNewPasscodeStrategy.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/31/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RISetNewPasscodeStrategy.h"
#import "RIPasscodeEntryState.h"
#import "RIPasscodeStrategySubclass.h"
#import "RIConstants.h"
#import "RISecureManager.h"

@interface RISetNewPasscodeStrategy ()

@property (strong, nonatomic) NSString *passcodeToConfirm;

@property (strong, nonatomic, readonly) RISecureManager *secureManager;

@end

@implementation RISetNewPasscodeStrategy

#pragma mark Property getters

- (RISecureManager *)secureManager {
    return RISecureManager.shared;
}

#pragma mark Setup strategy

- (void)setupStrategy {
    self.state = RIPasscodeEntryStateEnter;
    
    self.passcodeEntryView.titleLabel.text = kPasscodeEntrySetNewPasscodeOptionEnterTitleLabel;
}

#pragma mark Handle entry with state

- (void)handleEntryWithState:(RIPasscodeEntryState)state {
    [self.passcodeEntryView.dotsControl recolorDotsTo:0];
    self.passcodeCounter = 0;
    
    switch (state) {            
        case RIPasscodeEntryStateEnter:
            self.passcodeToConfirm = [self.enteredPasscode copy];
            self.enteredPasscode = [NSMutableString string];
            
            self.state = RIPasscodeEntryStateVerify;
            
            [self performSwipeAnimationForSubtype:kCATransitionFromRight];
            
            self.passcodeEntryView.titleLabel.text = kPasscodeEntrySetNewPasscodeOptionConfirmTitleLabel;
            self.passcodeEntryView.notMatchingPasscodesLabel.hidden = YES;
            
            break;
            
        case RIPasscodeEntryStateVerify:
            if ([self.passcodeToConfirm isEqualToString:self.enteredPasscode]) {
                [self proceedPasscodeSetting];
                return;
            }
            
            self.passcodeToConfirm = [NSMutableString string];
            self.enteredPasscode = [NSMutableString string];
            
            self.state = RIPasscodeEntryStateEnter;
            
            [self performSwipeAnimationForSubtype:kCATransitionFromLeft];
            
            self.passcodeEntryView.titleLabel.text = kPasscodeEntrySetNewPasscodeOptionEnterTitleLabel;
            self.passcodeEntryView.notMatchingPasscodesLabel.hidden = NO;
            
            break;
            
        default:
            break;
    }
}

#pragma mark Procees passcode setting

- (void)proceedPasscodeSetting {
    NSError *error;
    BOOL success = [self.secureManager setPasscode:self.enteredPasscode withError:&error];
    
    RIResponse *response = [[RIResponse alloc] initWithSuccess:success result:nil error:error];
    
    self.responseBlock(response);
    self.successfulResponseSent = YES;
}

@end
