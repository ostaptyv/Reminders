//
//  RIReminder+CoreDataProperties.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/26/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//
//

#import "RIReminder+CoreDataProperties.h"

@implementation RIReminder (CoreDataProperties)

+ (NSFetchRequest<RIReminder *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(RIReminder.class)];
}

@dynamic arrayOfImagePaths;
@dynamic date;
@dynamic text;

@end
