//
//  RISecureManagerError.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/11/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

typedef NS_ENUM(NSUInteger, RISecureManagerError) {
    RISecureManagerErrorValidationForbidden = 0,
    RISecureManagerErrorPasscodeAlreadySet,
    RISecureManagerErrorPasscodeNotSetToBeChanged,
    RISecureManagerErrorPasscodeNotValid,
    RISecureManagerErrorAppLockedOut,
    RISecureManagerErrorChangingToSamePasscode,
    RISecureManagerErrorPasscodeNotSetToEnableBiometry
};
