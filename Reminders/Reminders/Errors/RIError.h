//
//  RIError.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/13/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

typedef NS_ENUM(NSUInteger, RIError) {
    RIErrorCreateReminderEmptyContent,
    RIErrorCreateReminderUserCancel,
    RIErrorSecureManagerPasscodeAlreadySet,
    RIErrorSecureManagerPasscodeNotSetToBeChanged,
    RIErrorSecureManagerPasscodeNotValid,
    RIErrorSecureManagerChangingToSamePasscode,
};
