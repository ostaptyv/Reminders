//
//  RIBiometrics.h
//  RemindersTests
//
//  Created by Ostap Tyvonovych on 2/21/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LAContext.h>

@interface RIBiometrics : NSObject

@property (assign, nonatomic, class) BOOL isEnrolled;

+ (void)authenticationSuccessfulForBiometryType:(LABiometryType)biometryType;
+ (void)authenticationUnsuccessfulForBiometryType:(LABiometryType)biometryType;

@end
