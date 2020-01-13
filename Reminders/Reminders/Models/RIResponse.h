//
//  RIResponse.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/13/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIReminder.h"

@interface RIResponse : NSObject

@property (getter=isSuccess) BOOL success;

@property RIReminder * __nullable reminder;
@property NSError * __nullable error;

@end
