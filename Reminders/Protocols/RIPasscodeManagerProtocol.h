//
//  RIPasscodeManagerProtocol.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/18/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@protocol RIPasscodeManagerProtocol <NSObject>

+ (instancetype)sharedInstance;

- (BOOL)setPasscode:(NSString *)passcode forIdentifier:(NSString *)identifier withErrorCode:(NSInteger * __nullable)errorCode;
- (BOOL)resetExistingPasscode:(NSString *)passcode forIdentifier:(NSString *)identifier withErrorCode:(NSInteger * __nullable)errorCode;
- (BOOL)changePasscode:(NSString *)oldPasscode toNewPasscode:(NSString *)newPasscode forIdentifier:(NSString *)identifier withErrorCode:(NSInteger * __nullable)errorCode;

- (BOOL)validatePasscode:(NSString *)passcode forIdentifier:(NSString *)identifier withErrorCode:(NSInteger * __nullable)errorCode;

@end

NS_ASSUME_NONNULL_END
