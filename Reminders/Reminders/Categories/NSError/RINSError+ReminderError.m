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

+ (NSError *)generateReminderError:(RIError)reminderErrorEnumCase {
    NSString *localizedDesc;
    
    switch (reminderErrorEnumCase) {
        case RIErrorCreateReminderEmptyContent:
            localizedDesc = NSLocalizedString(@"User haven't provided neither any text nor any images in the create form, so there's no purpose to create a new reminder.", nil);
            break;
            
        case RIErrorCreateReminderUserCancel:
            localizedDesc = NSLocalizedString(@"User tapped cancel button.", nil);
            break;
            
        case RIErrorSecureManagerValidationForbidden:
            localizedDesc = NSLocalizedString(@"Passcode validation is forbidden since app lock out is active.", nil);
            break;
            
        case RIErrorSecureManagerPasscodeAlreadySet:
            localizedDesc = NSLocalizedString(@"Couldn't set the passcode since there's some existing one. Use -changePasscode:toNewPasscode:withError: instead.", nil);
            break;
            
        case RIErrorSecureManagerPasscodeNotSetToBeChanged:
            localizedDesc = NSLocalizedString(@"Can't change passcode since passcode isn't set. Use -setPasscode:withError: to do this.", nil);
            break;
            
        case RIErrorSecureManagerPasscodeNotValid:
            localizedDesc = NSLocalizedString(@"Entered passcode doesn't match with existing passcode, so operation could not be proceeded.", nil);
            break;
            
        case RIErrorSecureManagerAppLockedOut:
            localizedDesc = NSLocalizedString(@"User entered critical number of invalid passcodes, so temporary app lock out applied as a restriction.", nil);
            break;
            
        case RIErrorSecureManagerChangingToSamePasscode:
            localizedDesc = NSLocalizedString(@"Tried to change the passcode to the exisitng one. Action takes no effect.", nil);
            break;
            
        case RIErrorSecureManagerPasscodeNotSetToEnableBiometry:
            localizedDesc = NSLocalizedString(@"To enable biometry unlock you need to set up passcode first. Use -setPasscode:withError: and then try again.", nil);
            break;
    }
    
    NSDictionary<NSString *, NSString *> *userInfo = @{
        NSLocalizedDescriptionKey : localizedDesc
    };
    
    return [NSError errorWithDomain:kCreateReminderErrorDomain
                               code:reminderErrorEnumCase
                           userInfo:userInfo];
}

@end
