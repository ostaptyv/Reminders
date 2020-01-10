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

+ (NSString *)biometryLocalizedReasonForBiometryType:(LABiometryType)biometryType;

@end
