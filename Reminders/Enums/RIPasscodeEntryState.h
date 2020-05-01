//
//  RIPasscodeEntryState.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/2/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RIPasscodeEntryState) {
    RIPasscodeEntryStateConfirmOld = 0,
    RIPasscodeEntryStateEnter,
    RIPasscodeEntryStateVerify
};
