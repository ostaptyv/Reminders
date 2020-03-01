//
//  RIReminder+CoreDataProperties.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/26/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//
//

#import "RIReminder.h"

NS_ASSUME_NONNULL_BEGIN

@interface RIReminder (CoreDataProperties)

+ (NSFetchRequest<RIReminder *> *)fetchRequest;

@property (nonatomic, retain) NSArray<NSURL *> *arrayOfImageURLs;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *text;

@end

NS_ASSUME_NONNULL_END
