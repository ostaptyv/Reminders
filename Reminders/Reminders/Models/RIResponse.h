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

@property RIReminder *reminder;
@property NSError *error;

- (instancetype)initWithSuccess:(BOOL)success reminder:(RIReminder *)reminder error:(NSError *)error;

@end
