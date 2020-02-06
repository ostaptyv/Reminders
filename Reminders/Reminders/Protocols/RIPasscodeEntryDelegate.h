//
//  RIPasscodeEntryDelegate.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/2/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RIResponse.h"
#import "RIPasscodeEntryOption.h"

@protocol RIPasscodeEntryDelegate <NSObject>

@optional
- (void)didReceiveEntryEventWithResponse:(RIResponse *)response forEntryOption:(RIPasscodeEntryOption)option;

@end
