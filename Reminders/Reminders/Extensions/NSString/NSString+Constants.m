//
//  NSString+Constants.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/28/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "NSString+Constants.h"
#import <LocalAuthentication/LAContext.h>

@implementation NSString (Constants)

+ (NSString *)touchIdIconName {
    return @"touchIdIcon";
}
+ (NSString *)faceIdIconName {
    return @"faceIdIcon";
}

+ (NSString *)touchIdIconHexColor {
    return @"FF2D55";
}
+ (NSString *)faceIdIconHexColor {
    return @"0091FF";
}
+ (NSString *)numberPadWhiteThemeHexColor {
    return @"E3E5E6";
}

+ (NSString *)biometryLocalizedReasonForBiometryType:(LABiometryType)biometryType {
    switch (biometryType) {
        case LABiometryTypeFaceID:
            return @"Face ID haven't recognized your face. Please enter the passcode.";
            
            break;
        case LABiometryTypeTouchID:
            return @"Use Touch ID to unlock you reminders.";
            
        case LABiometryTypeNone:
            return @"No biometry identification available.";
            
            break;
    }
}
+ (NSString *)biometryLocalizedFallbackTitle {
    return @"Enter passcode";
}

@end