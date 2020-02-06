//
//  RISecureManager.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/4/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RISecureManager : NSObject

+ (nonnull instancetype)shared;

@property (assign, atomic, readonly) BOOL isPasscodeSet;

@property (assign, atomic, readonly) NSUInteger failedAttemptsCount;
@property (assign, atomic, readonly) BOOL isAppLockedOut;
@property (assign, atomic, readonly) NSUInteger lockOutTime;

- (BOOL)setPasscode:(nonnull NSString *)passcode withError:(NSError * __nullable * __nullable)error;
- (BOOL)resetExistingPasscode:(nonnull NSString *)existingPasscode withError:(NSError * __nullable * __nullable)error ;
- (BOOL)changePasscode:(nonnull NSString *)oldPasscode toNewPasscode:(nonnull NSString *)newPasscode withError:(NSError * __nullable * __nullable)error;

- (BOOL)validatePasscode:(nonnull NSString *)passcodeToValidate withError:(NSError * __nullable * __nullable)error;

+ (nonnull instancetype)alloc __attribute__((unavailable("RISecureManager is a singleton object; use +shared to get the object instead")));
- (nonnull instancetype)init __attribute__((unavailable("RISecureManager is a singleton object; use +shared to get the object instead")));

+ (nonnull instancetype)new __attribute__((unavailable("RISecureManager is a singleton object; use +shared to get the object instead")));

@end
