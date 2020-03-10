//
//  RISecureManager.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/4/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RISecureManager : NSObject

@property (strong, nonatomic, class, readonly) RISecureManager *sharedInstance;

@property (assign, nonatomic, readonly) BOOL isPasscodeSet;

@property (assign, nonatomic, readonly) NSUInteger failedAttemptsCount;
@property (assign, nonatomic, readonly) BOOL isAppLockedOut;
@property (assign, nonatomic, readonly) NSUInteger lockOutTime;

@property (assign, nonatomic, readonly) BOOL isBiometryEnabled;

- (BOOL)setPasscode:(NSString *)passcode withError:(NSError * __nullable * __nullable)error;
- (BOOL)resetExistingPasscode:(NSString *)existingPasscode withError:(NSError * __nullable * __nullable)error ;
- (BOOL)changePasscode:(NSString *)oldPasscode toNewPasscode:(NSString *)newPasscode withError:(NSError * __nullable * __nullable)error;

- (BOOL)validatePasscode:(NSString *)passcode withError:(NSError * __nullable * __nullable)error;

- (BOOL)setBiometryEnabled:(BOOL)isBiometryEnabled withError:(NSError * __nullable * __nullable)error;

+ (instancetype)alloc __attribute__((unavailable("RISecureManager is a singleton object; use 'sharedInstance' property to get the object instead")));
- (instancetype)init __attribute__((unavailable("RISecureManager is a singleton object; use 'sharedInstance' property to get the object instead")));

+ (instancetype)new __attribute__((unavailable("RISecureManager is a singleton object; use 'sharedInstance' property to get the object instead")));

@end

NS_ASSUME_NONNULL_END
