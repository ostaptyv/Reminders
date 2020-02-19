//
//  RISecureManager.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/4/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RISecureManager.h"
#import "RIPasscodeManager.h"
#import "RIPasscodeManagerProtocol.h"
#import "RINSError+ReminderError.h"
#import "RIConstants.h"

@interface RISecureManager ()

@property (strong, nonatomic, readonly) id<RIPasscodeManagerProtocol> passcodeManager;
@property (strong, nonatomic, readwrite) NSString *passcodeIdentifier;

@property (assign, nonatomic, readwrite) BOOL isPasscodeSet;
@property (assign, nonatomic, readwrite) BOOL isAppLockedOut;

@property (assign, nonatomic, readwrite) BOOL isBiometryEnabled;

@property (assign, nonatomic, readwrite) NSUInteger failedAttemptsCount;
@property (assign, nonatomic, readwrite) NSUInteger lockOutTime;

@end

@implementation RISecureManager

#pragma mark Property getters

- (id<RIPasscodeManagerProtocol>)passcodeManager {
    return RIPasscodeManager.shared;
}

#pragma mark Shared instance

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static RISecureManager *sharedInstance;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [RISecureManager new];
    });
    
    return sharedInstance;
}

#pragma mark Set passcode method

- (BOOL)setPasscode:(NSString *)passcode withError:(NSError * __nullable * __nullable)error {
    NSInteger errorCode;
    BOOL isSetSuccessful = [self.passcodeManager setPasscode:passcode forIdentifier:self.passcodeIdentifier withErrorCode:&errorCode];
    
    if (!isSetSuccessful) {
        if (error != nil) {
            RISecureManagerError errorEnumCase = errorCode == errRemindersPasscodeAlreadySet ? RISecureManagerErrorPasscodeAlreadySet : RISecureManagerErrorUnknown;
            *error = [NSError generateSecureManagerError:errorEnumCase];
        }
        return NO;
    }
    
    self.isPasscodeSet = YES;
    
    [self sendNotificationForName:RISecureManagerDidSetPasscodeNotification userInfo:nil];
    
    return YES;
}

#pragma mark Reset existing passcode method

- (BOOL)resetExistingPasscode:(NSString *)existingPasscode withError:(NSError * __nullable * __nullable)error {
    BOOL isPasscodeValid = [self validatePasscode:existingPasscode withError:error];
    
    if (!isPasscodeValid) {
        return NO;
    }
    
    NSInteger resetErrorCode;
    BOOL isResetSuccessful = [self.passcodeManager resetExistingPasscode:existingPasscode  forIdentifier:self.passcodeIdentifier withErrorCode:&resetErrorCode];
    
    if (!isResetSuccessful) {
        if (error != nil) {
            *error = [NSError generateSecureManagerError:RISecureManagerErrorUnknown];
        }
        return NO;
    }

    self.isPasscodeSet = NO;
    
    [self sendNotificationForName:RISecureManagerDidResetPasscodeNotification userInfo:nil];
    
    return YES;
}

#pragma mark Validate passcode method

- (BOOL)validatePasscode:(NSString *)passcode withError:(NSError * __nullable * __nullable)error {
    if (self.isAppLockedOut) {
        if (error != nil) {
            *error = [NSError generateSecureManagerError:RISecureManagerErrorValidationForbidden];
        }
        return NO;
    }
    
    NSInteger errorCode;
    BOOL isPasscodeValid = [self.passcodeManager validatePasscode:passcode forIdentifier:self.passcodeIdentifier withErrorCode:&errorCode];
    
    if (!isPasscodeValid) {
        switch (errorCode) {
            case errSecItemNotFound:
                if (error != nil) {
                    *error = [NSError generateSecureManagerError:RISecureManagerErrorPasscodeNotSet];
                }
                break;
                
            case errRemindersPasscodeNotValid:
                self.failedAttemptsCount++;
                
                [self handleInvalidEntryWithError:error];
                break;

            default:
                if (error != nil) {
                    *error = [NSError generateSecureManagerError:RISecureManagerErrorUnknown];
                }
                break;
        }
        
        return NO;
    }
    
    self.failedAttemptsCount = 0;
    return YES;
}

#pragma mark Change passcode method

- (BOOL)changePasscode:(NSString *)oldPasscode toNewPasscode:(NSString *)newPasscode withError:(NSError * __nullable * __nullable)error {
    BOOL isPasscodeValid = [self validatePasscode:oldPasscode withError:error];
    
    if (!isPasscodeValid) {
        return NO;
    }
    
    if ([newPasscode isEqualToString:oldPasscode]) {
        if (error != nil) {
            *error = [NSError generateSecureManagerError:RISecureManagerErrorChangingToSamePasscode];
        }
        return NO;
    }
    
    NSInteger changeErrorCode;
    BOOL isChangeSuccessful = [self.passcodeManager changePasscode:oldPasscode toNewPasscode:newPasscode forIdentifier:self.passcodeIdentifier withErrorCode:&changeErrorCode];
    
    if (!isChangeSuccessful) {
        if (error != nil) {
            RISecureManagerError errorEnumCase = changeErrorCode == errRemindersChangeToSameValue ? RISecureManagerErrorChangingToSamePasscode : RISecureManagerErrorUnknown;
            *error = [NSError generateSecureManagerError:errorEnumCase];
        }
        return NO;
    }
    
    return YES;
}

#pragma mark Set biometry available method

- (BOOL)setBiometryEnabled:(BOOL)isBiometryEnabled withError:(NSError * __nullable * __nullable)error {
    
    if (!self.isPasscodeSet) {
        if (error != nil) {
            *error = [NSError generateSecureManagerError:RISecureManagerErrorPasscodeNotSet];
        }
        return NO;
    } else {
        
        self.isBiometryEnabled = isBiometryEnabled;
        return YES;
    }
}

#pragma mark Handle invalid entry

- (void)handleInvalidEntryWithError:(NSError **)error {
    if (self.failedAttemptsCount % 5 == 0 && self.failedAttemptsCount != 0) {
        if (error != nil) {
            *error = [NSError generateSecureManagerError:RISecureManagerErrorAppLockedOut];
        }
        
        [self manageAppLockOutEvent];
    } else {
        if (error != nil) {
            *error = [NSError generateSecureManagerError:RISecureManagerErrorPasscodeNotValid];
        }
    }
}

#pragma mark Manage app lock out event

- (void)manageAppLockOutEvent {
    double quadraticFactor = pow(self.failedAttemptsCount / 5, 2);
    double numberOfSeconds = quadraticFactor * 60;
    
    NSDictionary<NSString *, id> *userInfo = @{
        kRISecureManagerFailedAttemptsCountKey: [NSNumber numberWithUnsignedInteger:self.failedAttemptsCount],
        kRISecureManagerLockOutTimeKey: [NSNumber numberWithDouble:numberOfSeconds]
    };
    
    dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(numberOfSeconds * NSEC_PER_SEC));
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    [self sendNotificationForName:RISecureManagerAppLockOutAppliedNotification userInfo:userInfo];
    self.isAppLockedOut = YES;
    self.lockOutTime = numberOfSeconds;
    
    dispatch_after(dispatchTime, mainQueue, ^{
        [self sendNotificationForName:RISecureManagerAppLockOutReleasedNotification userInfo:nil];
        self.isAppLockedOut = NO;
        self.lockOutTime = 0;
    });
}

#pragma mark Send notification method

- (void)sendNotificationForName:(NSString *)notificationName userInfo:(NSDictionary<NSString *, id> *)userInfo {
    NSNotification *notification = [[NSNotification alloc] initWithName:notificationName object:self userInfo:userInfo];
    
    [NSNotificationCenter.defaultCenter postNotification:notification];
}

#pragma mark Initializers

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.passcodeIdentifier = [[NSUUID UUID] UUIDString];
    }
    
    return self;
}

@end
