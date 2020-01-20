//
//  RIResponse.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/13/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RIResponse.h"

@implementation RIResponse

- (instancetype)initWithSuccess:(BOOL)success reminder:(RIReminder *)reminder error:(NSError *)error {
    self = [super init];
    
    if (self) {
        self.success = success;
        self.reminder = reminder;
        self.error = error;
    }
    
    return self;
}

@end
