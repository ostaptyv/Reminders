//
//  RIURLSchemeHandlerService.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/24/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIReminder.h"

@interface RIURLSchemeHandlerService : NSObject

- (RIReminder *)parseReminderSchemeURL:(NSURL *)url;

@end
