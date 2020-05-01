//
//  RIPasscodeManager.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/14/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIPasscodeManagerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

//ERRORS:
static const NSInteger errRemindersPasscodeAlreadySet = -80000;
static const NSInteger errRemindersChangeToSameValue = -80001;
static const NSInteger errRemindersPasscodeNotValid = -80002;

@interface RIPasscodeManager : NSObject <RIPasscodeManagerProtocol>

+ (instancetype)sharedInstance;

- (BOOL)setPasscode:(NSString *)passcode forIdentifier:(NSString *)identifier withErrorCode:(NSInteger * __nullable)errorCode;
- (BOOL)resetExistingPasscode:(NSString *)passcode forIdentifier:(NSString *)identifier withErrorCode:(NSInteger * __nullable)errorCode;
- (BOOL)changePasscode:(NSString *)oldPasscode toNewPasscode:(NSString *)newPasscode forIdentifier:(NSString *)identifier withErrorCode:(NSInteger * __nullable)errorCode;

- (BOOL)validatePasscode:(NSString *)passcode forIdentifier:(NSString *)identifier withErrorCode:(NSInteger * __nullable)errorCode;

+ (instancetype)alloc __attribute__((unavailable("RIPasscodeManager is a singleton object; use 'sharedInstance' property to get the object instead")));
- (instancetype)init __attribute__((unavailable("RIPasscodeManager is a singleton object; use 'sharedInstance' property to get the object instead")));

+ (instancetype)new __attribute__((unavailable("RIPasscodeManager is a singleton object; use 'sharedInstance' property to get the object instead")));

@end

NS_ASSUME_NONNULL_END
