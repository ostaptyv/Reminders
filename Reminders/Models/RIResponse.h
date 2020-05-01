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

@property (assign, nonatomic, getter=isSuccess) BOOL success;

@property (strong, nonatomic) id result;
@property (strong, nonatomic) NSError *error;

- (instancetype)initWithSuccess:(BOOL)success result:(id)result error:(NSError *)error;

@end
