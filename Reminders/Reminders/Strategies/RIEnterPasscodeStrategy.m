//
//  RIEnterPasscodeStrategy.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/3/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RIPasscodeStrategySubclass.h"
#import "RIEnterPasscodeStrategy.h"
#import "RIConstants.h"
#import "RIError.h"
#import "RINSError+ReminderError.h"
#import "RISecureManager.h"

@implementation RIEnterPasscodeStrategy

#pragma mark -setupStrategy

- (void)setupStrategy {
    self.state = RIPasscodeEntryStateEnter;
    
    self.passcodeEntryView.titleLabel.text = kPasscodeEntryEnterPasscodeOptionNavigationBarTitle;
    
    if (RISecureManager.shared.isAppLockedOut) {
        self.passcodeEntryView.titleLabel.text = [self makeTryAgainStringForNumberOfSeconds:RISecureManager.shared.lockOutTime];
        self.editingDisabled = YES;
    } else {
        self.passcodeEntryView.titleLabel.text = kPasscodeEntryEnterPasscodeOptionTitleLabel;
        self.editingDisabled = NO;
    }
    
    [self registerForSecureManagerNotifications];
}

#pragma mark -handleEntryWithState:

- (void)handleEntryWithState:(RIPasscodeEntryState)state {
    [self.passcodeEntryView.dotsControl recolorDotsTo:0];
    self.passcodeCounter = 0;
    
    NSError *error;
    BOOL isOperationSuccessful = [RISecureManager.shared resetExistingPasscode:self.enteredPasscode withError:&error];
    
    RIResponse *response = [[RIResponse alloc] initWithSuccess:isOperationSuccessful result:nil error:error];
    self.responseBlock(response);
    
    switch (state) {
        case RIPasscodeEntryStateEnter:
            self.enteredPasscode = [NSMutableString string];
            
            if (isOperationSuccessful) {
                self.successfulResponseSent = YES;
            }
            break;
            
        default:
            NSLog(@"RIEnterPasscodeStrategy ERROR: other entry option passed to call");
            break;
    }
}

#pragma mark -registerForSecureManagerNotifications

- (void)registerForSecureManagerNotifications {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didSendPasscodeNotValidNotification:) name:RISecureManagerPasscodeNotValidNotification object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didSendAppLockOutAppliedNotification:) name:RISecureManagerAppLockOutAppliedNotification object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didSendAppLockOutReleasedNotification:) name:RISecureManagerAppLockOutReleasedNotification object:nil];
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
    
    [self changeTitleTextAnimatableWithString:kPasscodeEntryEnterPasscodeOptionTitleLabel];
}

#pragma mark -makeTryAgainTextForDispatchTime:

- (NSString *)makeTryAgainStringForNumberOfSeconds:(double)numberOfSeconds {
    NSString *pluralSuffix = numberOfSeconds > 60.0 ? @"s" : @"";
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.roundingMode = NSNumberFormatterRoundHalfUp;
    
    NSString *stringNumber = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:(numberOfSeconds / 60.0)]];
    
    return [NSString stringWithFormat:@"Try again in %@ minute%@", stringNumber, pluralSuffix];
}

#pragma mark -changeTitleTextAnimatableWithString:

- (void)changeTitleTextAnimatableWithString:(NSString *)string {
    [UIView transitionWithView:self.passcodeEntryView.titleLabel
                      duration:kPasscodeEntryTryAgainTitleAnimationDuration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
        
        self.passcodeEntryView.titleLabel.text = string;
    } completion:nil];
}

@end
