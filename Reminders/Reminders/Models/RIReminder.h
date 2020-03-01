//
//  RIReminder.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/22/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "RIReminderRaw.h"

NS_ASSUME_NONNULL_BEGIN

@interface RIReminder : NSManagedObject 

@property (strong, nonatomic, readonly, class) NSString *entityName;

- (RIReminderRaw *)transformToRaw;

@end

NS_ASSUME_NONNULL_END

#import "RIReminder+CoreDataProperties.h"
