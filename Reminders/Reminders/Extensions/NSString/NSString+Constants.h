//
//  NSString+Constants.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/28/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LAContext.h>

@interface NSString (Constants)

+ (NSString *)touchIdIconName;
+ (NSString *)faceIdIconName;

+ (NSString *)touchIdIconHexColor;
+ (NSString *)faceIdIconHexColor;
+ (NSString *)numberPadWhiteThemeHexColor;

+ (NSString *)biometryLocalizedReasonForBiometryType:(LABiometryType)biometryType;
+ (NSString *)biometryLocalizedFallbackTitle;

@end