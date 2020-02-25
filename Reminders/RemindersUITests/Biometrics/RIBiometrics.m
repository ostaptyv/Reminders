//
//  RIBiometrics.m
//  RemindersTests
//
//  Created by Ostap Tyvonovych on 2/21/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RIBiometrics.h"
#import "notify.h"

@implementation RIBiometrics

static BOOL _isEnrolled;

#pragma mark Property getters

+ (BOOL)isEnrolled {
    return _isEnrolled;
}

#pragma mark Property setters

+ (void)setIsEnrolled:(BOOL)isEnrolled {
    int token;
    NSUInteger state = isEnrolled;

    notify_register_check("com.apple.BiometricKit.enrollmentChanged", &token);
    notify_set_state(token, state);
    notify_post("com.apple.BiometricKit.enrollmentChanged");
    
    _isEnrolled = isEnrolled;
}

#pragma mark Touch ID authentication

+ (void)touchMatching {
    notify_post("com.apple.BiometricKit_Sim.fingerTouch.match");
}

+ (void)touchNotMatching {
    notify_post("com.apple.BiometricKit_Sim.fingerTouch.nomatch");
}

#pragma mark Face ID authentication

+ (void)faceMatching {
    notify_post("com.apple.BiometricKit_Sim.pearl.match");
}

+ (void)faceNotMatching {
    notify_post("com.apple.BiometricKit_Sim.pearl.nomatch");
}

#pragma mark Common methods for successful or unsuccessful authentication

+ (void)authenticationSuccessfulForBiometryType:(LABiometryType)biometryType {
    switch (biometryType) {
        case LABiometryTypeTouchID:
            [RIBiometrics touchMatching];
            break;
        case LABiometryTypeFaceID:
            [RIBiometrics faceMatching];
            break;
            
        default:
            NSLog(@"UNRECOGNIZED BIOMETRY TYPE IN RIBiometrics CLASS");
            break;
    }
}

+ (void)authenticationUnsuccessfulForBiometryType:(LABiometryType)biometryType {
    switch (biometryType) {
        case LABiometryTypeTouchID:
            [RIBiometrics touchNotMatching];
            break;
        case LABiometryTypeFaceID:
            [RIBiometrics faceNotMatching];
            break;
            
        default:
            NSLog(@"UNRECOGNIZED BIOMETRY TYPE IN RIBiometrics CLASS");
            break;
    }
}

@end
