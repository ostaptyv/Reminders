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
@property (strong, atomic) NSString *passcode;

@property (assign, atomic, readwrite) BOOL isPasscodeSet;
@property (assign, atomic, readwrite) BOOL isAppLockedOut;

@property (assign, atomic, readwrite) BOOL isBiometryEnabled;

@property (assign, atomic, readwrite) NSUInteger failedAttemptsCount;
@property (assign, atomic, readwrite) NSUInteger lockOutTime;

@end

@implementation RISecureManager

#pragma mark +shared

+ (nonnull instancetype)shared {
    static dispatch_once_t onceToken;
    static RISecureManager *sharedInstance;
    
    dispatch_once(&onceToken, ^{ sharedInstance = [RISecureManager new]; });
    
    return sharedInstance;
}

#pragma mark -setPasscode:withError:

- (BOOL)setPasscode:(nonnull NSString *)passcode withError:(NSError * __nullable * __nullable)error {
    if (self.passcode.length > 0) {
        if (error != nil) {
            *error = [NSError generateReminderError:RIErrorSecureManagerPasscodeAlreadySet];
        }
        
        return NO;
    }
    
    self.passcode = [passcode copy];
    self.isPasscodeSet = YES;
    
    [self sendNotificationForName:RISecureManagerDidSetPasscodeNotification userInfo:nil];
    
    return YES;
}

#pragma mark -resetExistingPasscode:withError:

- (BOOL)resetExistingPasscode:(nonnull NSString *)existingPasscode withError:(NSError * __nullable * __nullable)error {
    BOOL isPasscodeValid = [self validatePasscode:existingPasscode withError:error];
    
    if (!isPasscodeValid) {
        return NO;
    }

    self.passcode = @"";
    self.isPasscodeSet = NO;
    
    [self sendNotificationForName:RISecureManagerDidResetPasscodeNotification userInfo:nil];
    
    return YES;
}

#pragma mark -changePasscode:toNewPasscode:withError:

- (BOOL)changePasscode:(nonnull NSString *)oldPasscode toNewPasscode:(nonnull NSString *)newPasscode withError:(NSError * __nullable * __nullable)error {
    BOOL isPasscodeValid = [self validatePasscode:oldPasscode withError:error];
    
    if (!isPasscodeValid) {
        return NO;
    }
    
    if (self.passcode.length == 0) {
        if (error != nil) {
            *error = [NSError generateReminderError:RIErrorSecureManagerPasscodeNotSetToBeChanged];
        }
        
        return NO;
    }
    
    if ([newPasscode isEqualToString:self.passcode]) {
        if (error != nil) {
            *error = [NSError generateReminderError:RIErrorSecureManagerChangingToSamePasscode];
        }
        
        return NO;
    }
    
    self.passcode = [newPasscode copy];
    
    return YES;
}

#pragma mark -validatePasscode:withError:

- (BOOL)validatePasscode:(nonnull NSString *)passcodeToValidate withError:(NSError * __nullable * __nullable)error {
    if (self.isAppLockedOut) {
        *error = [NSError generateReminderError:RIErrorSecureManagerValidationForbidden];
        
        return NO;
    }
    
    if (![passcodeToValidate isEqualToString:self.passcode]) {
        self.failedAttemptsCount++;
        
        [self handleInvalidEntryWithError:error];
            
        return NO;
    } else {
        self.failedAttemptsCount = 0;
        [self sendNotificationForName:RISecureManagerFailedAttemptsCountResetNotification userInfo:nil];
        
        return YES;
    }
}

#pragma mark -setBiometryAvailable:withError:

- (BOOL)setBiometryEnabled:(BOOL)isBiometryEnabled withError:(NSError * _Nullable __autoreleasing *)error {
    
    if (self.passcode.length == 0 && !isBiometryEnabled) { // if isBiometryEnabled == NO, we allow user to set self.isBiometryEnabled property value to NO
        if (error != nil) {
            *error = [NSError generateReminderError:RIErrorSecureManagerPasscodeNotSetToEnableBiometry];
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
            *error = [NSError generateReminderError:RIErrorSecureManagerAppLockedOut];
        }
        
        [self manageAppLockOutEvent];
    } else {
        if (error != nil) {
            *error = [NSError generateReminderError:RIErrorSecureManagerPasscodeNotValid];
        }
        
        [self managePasscodeNotValidEvent];
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
    });
}

#pragma mark Manage passcode not valid event

- (void)managePasscodeNotValidEvent {
    NSDictionary<NSString *, id> *userInfo = @{
        kRISecureManagerFailedAttemptsCountKey: [NSNumber numberWithUnsignedInteger:self.failedAttemptsCount]
    };
    
    [self sendNotificationForName:RISecureManagerPasscodeNotValidNotification userInfo:userInfo];
}

#pragma mark -sendNotificationForName:serInfo:

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
