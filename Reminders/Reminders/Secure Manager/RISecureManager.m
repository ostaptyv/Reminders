//
//  RISecureManager.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/4/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RISecureManager.h"
#import "RINSError+ReminderError.h"
#import "RIConstants.h"

@interface RISecureManager ()

// REALLY secure passcode store; no way to compromise
@property (strong, nonatomic) NSString *passcode;

@property (assign, nonatomic, readwrite) BOOL isPasscodeSet;
@property (assign, nonatomic, readwrite) BOOL isAppLockedOut;

@property (assign, nonatomic, readwrite) BOOL isBiometryEnabled;

@property (assign, nonatomic, readwrite) NSUInteger failedAttemptsCount;
@property (assign, nonatomic, readwrite) NSUInteger lockOutTime;

@end

@implementation RISecureManager

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
    if (self.passcode.length > 0) {
        if (error != nil) {
            *error = [NSError generateSecureManagerError:RISecureManagerErrorPasscodeAlreadySet];
        }
        
        return NO;
    }
    
    self.passcode = [passcode copy];
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

    self.passcode = @"";
    self.isPasscodeSet = NO;
    
    [self sendNotificationForName:RISecureManagerDidResetPasscodeNotification userInfo:nil];
    
    return YES;
}

#pragma mark Passcode validation method

- (BOOL)validatePasscode:(NSString *)passcode withError:(NSError * __nullable * __nullable)error {
    if (self.isAppLockedOut) {
        if (error != nil) {
            *error = [NSError generateSecureManagerError:RISecureManagerErrorValidationForbidden];
        }
        
        return NO;
    }
    
    if (![passcode isEqualToString:self.passcode]) {
        self.failedAttemptsCount++;
        
        [self handleInvalidEntryWithError:error];
        
        return NO;
    } else {
        self.failedAttemptsCount = 0;
        
        return YES;
    }
}

#pragma mark Change passcode method

- (BOOL)changePasscode:(NSString *)oldPasscode toNewPasscode:(NSString *)newPasscode withError:(NSError * __nullable * __nullable)error {
    BOOL isPasscodeValid = [self validatePasscode:oldPasscode withError:error];
    
    if (!isPasscodeValid) {
        return NO;
    }
    
    if (self.passcode.length == 0) {
        if (error != nil) {
            *error = [NSError generateSecureManagerError:RISecureManagerErrorPasscodeNotSetToBeChanged];
        }
        
        return NO;
    }
    
    if ([newPasscode isEqualToString:self.passcode]) {
        if (error != nil) {
            *error = [NSError generateSecureManagerError:RISecureManagerErrorChangingToSamePasscode];
        }
        
        return NO;
    }
    
    self.passcode = [newPasscode copy];
    
    return YES;
}

#pragma mark Set biometry available method

- (BOOL)setBiometryEnabled:(BOOL)isBiometryEnabled withError:(NSError * __nullable * __nullable)error {
    
    if (self.passcode.length == 0 && !isBiometryEnabled) { // if isBiometryEnabled == NO, we allow user to set self.isBiometryEnabled property value to NO
        if (error != nil) {
            *error = [NSError generateSecureManagerError:RISecureManagerErrorPasscodeNotSetToEnableBiometry];
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
        self.passcode = @"";
    }
    
    return self;
}

@end
