//
//  RIURLSchemeHandlerService.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/24/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIReminderRaw.h"

@interface RIURLSchemeHandlerService : NSObject

- (RIReminderRaw *)parseReminderSchemeURL:(NSURL *)url;

@end
