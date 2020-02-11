//
//  RINSString+Constants.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/28/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "RINSString+Constants.h"

@implementation NSString (Constants)

+ (NSString *)biometryLocalizedReasonForBiometryType:(LABiometryType)biometryType {
    switch (biometryType) {
        case LABiometryTypeFaceID:
            return @"Face ID haven't recognized your face. Please enter the passcode.";
        case LABiometryTypeTouchID:
            return @"Use Touch ID to unlock your reminders.";
        case LABiometryTypeNone:
            return @"No biometry identification available.";
        default:
            return @"NEW ENUM CASE DETECTED; UPDATE RINSString+Constants.m FILE";
    }
}

@end
