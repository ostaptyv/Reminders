//
//  RICoreDataStack.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/27/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface RICoreDataStack : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

- (void)saveData;

- (instancetype)initWithMomdName:(NSString *)momdName;

@end

NS_ASSUME_NONNULL_END
