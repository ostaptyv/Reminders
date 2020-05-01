//
//  RISecureManagerError.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/11/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

typedef NS_ENUM(NSUInteger, RISecureManagerError) {
    RISecureManagerErrorUnknown = 0,
    RISecureManagerErrorValidationForbidden,
    RISecureManagerErrorPasscodeAlreadySet,
    RISecureManagerErrorPasscodeNotSet,
    RISecureManagerErrorPasscodeNotValid,
    RISecureManagerErrorAppLockedOut,
    RISecureManagerErrorChangingToSamePasscode
};
