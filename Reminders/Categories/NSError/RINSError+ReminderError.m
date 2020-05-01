//
//  RINSError+ReminderError.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/3/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RINSError+ReminderError.h"
#import "RIConstants.h"

@implementation NSError (ReminderError)

+ (NSError *)generateReminderError:(RIError)errorCode {
    NSString *localizedDesc;
    
    switch (errorCode) {
        case RIErrorCreateReminderEmptyContent:
            localizedDesc = NSLocalizedString(@"User haven't provided neither any text nor any images in the create form, so there's no purpose to create a new reminder.", nil);
            break;
            
        case RIErrorCreateReminderUserCancel:
            localizedDesc = NSLocalizedString(@"User tapped cancel button.", nil);
            break;
    }
    
    NSDictionary<NSString *, NSString *> *userInfo = @{
        NSLocalizedDescriptionKey : localizedDesc
    };
    
    return [NSError errorWithDomain:kRIErrorDomain
                               code:errorCode
                           userInfo:userInfo];
}

+ (NSError *)generateSecureManagerError:(RISecureManagerError)errorCode {
    NSString *localizedDesc;
    
    switch (errorCode) {
        case RISecureManagerErrorUnknown:
            localizedDesc = NSLocalizedString(@"Unknown error was detected. There may be some issue with passcode proccessing unit, please contact developers to get more information.", nil);
            break;
            
        case RISecureManagerErrorValidationForbidden:
            localizedDesc = NSLocalizedString(@"Passcode validation is forbidden since app lock out is active.", nil);
            break;
            
        case RISecureManagerErrorPasscodeAlreadySet:
            localizedDesc = NSLocalizedString(@"Couldn't set the passcode since there's some existing one. Use -changePasscode:toNewPasscode:withError: instead.", nil);
            break;
            
        case RISecureManagerErrorPasscodeNotSet:
            localizedDesc = NSLocalizedString(@"Passcode not set, so operation can't be proceeded. Use -setPasscode:withError: to do this.", nil);
            break;
            
        case RISecureManagerErrorPasscodeNotValid:
            localizedDesc = NSLocalizedString(@"Entered passcode doesn't match with existing passcode, so operation could not be proceeded.", nil);
            break;
            
        case RISecureManagerErrorAppLockedOut:
            localizedDesc = NSLocalizedString(@"User entered critical number of invalid passcodes, so temporary app lock out applied as a restriction.", nil);
            break;
            
        case RISecureManagerErrorChangingToSamePasscode:
            localizedDesc = NSLocalizedString(@"Tried to change the passcode to the exisitng one. Action takes no effect.", nil);
            break;
    }
    
    NSDictionary<NSString *, NSString *> *userInfo = @{
        NSLocalizedDescriptionKey : localizedDesc
    };
    
    return [NSError errorWithDomain:kRISecureManagerErrorDomain
                               code:errorCode
                           userInfo:userInfo];
}

@end
