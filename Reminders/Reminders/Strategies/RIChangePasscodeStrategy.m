//
//  RIChangePasscodeStrategy.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/3/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RIChangePasscodeStrategy.h"
#import "RIPasscodeStrategySubclass.h"
#import "RIPasscodeEntryState.h"
#import "RIConstants.h"
#import "RIError.h"
#import "RINSError+ReminderError.h"
#import "RISecureManager.h"

@interface RIChangePasscodeStrategy ()

@property (strong, nonatomic) NSString *oldPasscode;
@property (strong, nonatomic) NSString *passcodeToConfirm;

@property (assign, nonatomic) BOOL shouldChangePasscode;

@end

@implementation RIChangePasscodeStrategy

#pragma mark Setup startegy

- (void)setupStrategy {
    self.state = RIPasscodeEntryStateConfirmOld;
    
    self.passcodeEntryView.titleLabel.text = kPasscodeEntryChangePasscodeOptionOldPasscodeTitleLabel;
    
    if (RISecureManager.shared.isAppLockedOut) {
        self.passcodeEntryView.titleLabel.text = [self makeTryAgainStringForNumberOfSeconds:RISecureManager.shared.lockOutTime];
        self.editingDisabled = YES;
    } else {
        self.passcodeEntryView.titleLabel.text = kPasscodeEntryEnterPasscodeOptionTitleLabel;
        self.editingDisabled = NO;
    }
    
    [self registerForSecureManagerNotifications];
}

#pragma mark Handle entry with state

- (void)handleEntryWithState:(RIPasscodeEntryState)state {
    [self.passcodeEntryView.dotsControl recolorDotsTo:0];
    self.passcodeCounter = 0;
    
    NSError *passcodeValidationError;
    BOOL isPasscodeValid;
    
    switch (state) {
        case RIPasscodeEntryStateConfirmOld:
            isPasscodeValid = [RISecureManager.shared validatePasscode:self.enteredPasscode withError:&passcodeValidationError];
            
            self.oldPasscode = [self.enteredPasscode copy];
            self.enteredPasscode = [NSMutableString string];
            
            if (!isPasscodeValid) {
                RIResponse *response = [[RIResponse alloc] initWithSuccess:NO result:nil error:passcodeValidationError];
                
                self.responseBlock(response);
                return;
            }
            
            self.state = RIPasscodeEntryStateEnter;
            
            [self performSwipeAnimationForSubtype:kCATransitionFromRight];
            
            self.passcodeEntryView.titleLabel.text = kPasscodeEntryChangePasscodeOptionNewPasscodeTitleLabel;
            
            break;
            
        case RIPasscodeEntryStateEnter:
            self.passcodeToConfirm = [self.enteredPasscode copy];
            self.enteredPasscode = [NSMutableString string];
            
            self.state = RIPasscodeEntryStateVerify;
            
            [self performSwipeAnimationForSubtype:kCATransitionFromRight];
            
            self.passcodeEntryView.titleLabel.text = kPasscodeEntryChangePasscodeOptionVerifyPasscodeTitleLabel;
            self.passcodeEntryView.notMatchingPasscodesLabel.hidden = YES;
            
            break;
            
        case RIPasscodeEntryStateVerify:
            if ([self.passcodeToConfirm isEqualToString:self.enteredPasscode]) {
                NSError *changePasscodeError;
                BOOL isChangePasscodeSuccessful = [RISecureManager.shared changePasscode:self.oldPasscode toNewPasscode:self.enteredPasscode withError:&changePasscodeError];
                
                RIResponse *response = [[RIResponse alloc] initWithSuccess:isChangePasscodeSuccessful result:nil error:changePasscodeError];
                
                self.responseBlock(response);
                self.successfulResponseSent = YES;
                return;
            }
            
            self.passcodeToConfirm = [NSMutableString string];
            self.enteredPasscode = [NSMutableString string];
            
            self.state = RIPasscodeEntryStateEnter;
            
            [self performSwipeAnimationForSubtype:kCATransitionFromLeft];
            
            self.passcodeEntryView.notMatchingPasscodesLabel.hidden = NO;
            self.passcodeEntryView.titleLabel.text = kPasscodeEntryChangePasscodeOptionNewPasscodeTitleLabel;

            break;
            
        default:
            break;
    }
}

#pragma mark Register for secure manager notifications

- (void)registerForSecureManagerNotifications {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didSendPasscodeNotValidNotification:) name:RISecureManagerPasscodeNotValidNotification object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didSendAppLockOutAppliedNotification:) name:RISecureManagerAppLockOutAppliedNotification object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didSendAppLockOutReleasedNotification:) name:RISecureManagerAppLockOutReleasedNotification object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didSendFailedAttemptsCountResetNotification:) name:RISecureManagerFailedAttemptsCountResetNotification object:nil];
}

#pragma mark Notifications handling

- (void)didSendPasscodeNotValidNotification:(NSNotification *)notification {
    NSNumber *wrappedFailedAttemptsCount = (NSNumber *)notification.userInfo[kRISecureManagerFailedAttemptsCountKey];
    double failedAttemptsCount = wrappedFailedAttemptsCount.unsignedIntegerValue;
    
    self.passcodeEntryView.failedAttemptsCount = failedAttemptsCount;
}

- (void)didSendAppLockOutAppliedNotification:(NSNotification *)notification {
    NSNumber *wrappedNumberOfSeconds = (NSNumber *)notification.userInfo[kRISecureManagerLockOutTimeKey];
    NSNumber *wrappedFailedAttemptsCount = (NSNumber *)notification.userInfo[kRISecureManagerFailedAttemptsCountKey];
    
    double numberOfSeconds = wrappedNumberOfSeconds.doubleValue;
    double failedAttemptsCount = wrappedFailedAttemptsCount.unsignedIntegerValue;
    
    self.editingDisabled = YES;
    
    NSString *tryAgainString = [self makeTryAgainStringForNumberOfSeconds:numberOfSeconds];
    [self changeTitleTextAnimatableWithString:tryAgainString];
    
    self.passcodeEntryView.failedAttemptsCount = failedAttemptsCount;
}

- (void)didSendAppLockOutReleasedNotification:(NSNotification *)notification {
    self.editingDisabled = NO;
    
    [self changeTitleTextAnimatableWithString:kPasscodeEntryChangePasscodeOptionOldPasscodeTitleLabel];
}

- (void)didSendFailedAttemptsCountResetNotification:(NSNotification *)notification {
    self.passcodeEntryView.failedAttemptsCount = 0;
}

#pragma mark Private methods for internal purposes

- (NSString *)makeTryAgainStringForNumberOfSeconds:(double)numberOfSeconds {
    NSString *pluralSuffix = numberOfSeconds > 60.0 ? @"s" : @"";
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.roundingMode = NSNumberFormatterRoundHalfUp;
    
    NSString *stringNumber = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:(numberOfSeconds / 60.0)]];

    return [NSString stringWithFormat:@"Try again in %@ minute%@", stringNumber, pluralSuffix];
}

- (void)changeTitleTextAnimatableWithString:(NSString *)string {
    [UIView transitionWithView:self.passcodeEntryView.titleLabel
                      duration:kPasscodeEntryTryAgainTitleAnimationDuration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
        
        self.passcodeEntryView.titleLabel.text = string;
    } completion:nil];
}

@end
