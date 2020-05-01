//
//  RICoreDataStack.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/27/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RICoreDataStack.h"

typedef NS_ENUM(NSUInteger, RIStoreType) {
    RISQLiteStoreType,
    RIBinaryStoreType,
    RIInMemoryStoreType
};

@interface RICoreDataStack ()

@property (strong, nonatomic, readonly) NSURL *documentsDirectoryURL;
@property (strong, nonatomic, readwrite) NSString *momdName;

@property (strong, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic, readonly) NSManagedObjectContext *parentManagedObjectContext;
@property (strong, nonatomic, readonly) NSManagedObjectContext *childManagedObjectContext;

@end

@implementation RICoreDataStack

@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize parentManagedObjectContext = _parentManagedObjectContext;
@synthesize childManagedObjectContext = _childManagedObjectContext;

#pragma mark - Property getters

- (NSURL *)documentsDirectoryURL {
    NSError *error;
    NSURL *result = [NSFileManager.defaultManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    
    if (error != nil) {
        NSLog(@"DOCUMENTS DIRECTORY URL ERROR: %@", error);
        return nil;
    }

    return result;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *momURL = [NSBundle.mainBundle URLForResource:self.momdName withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    
    _managedObjectModel = mom;
    return mom;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    RIStoreType storeType = RISQLiteStoreType;
    NSURL *persistentStoreURL;
    
    switch (storeType) {
        case RISQLiteStoreType: {
            NSString *path = [NSString stringWithFormat:@"%@.sqlite", self.momdName];
            persistentStoreURL = [self.documentsDirectoryURL URLByAppendingPathComponent:path];
        }
            break;
            
        default:
            persistentStoreURL = [NSURL new];
            break;
    }
    
    NSError *error;
    NSString *storeTypeString = [self convertStoreTypeToString:storeType];
    [coordinator addPersistentStoreWithType:storeTypeString
                              configuration:nil
                                        URL:persistentStoreURL
                                    options:@{ NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES }
                                      error:&error];
    
    if (error != nil) {
        NSLog(@"PERSISTENT STORE CREATION ERROR: %@", error);
    }
    
    _persistentStoreCoordinator = coordinator;
    return coordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    return self.childManagedObjectContext;
}

- (NSManagedObjectContext *)parentManagedObjectContext {
    if (_parentManagedObjectContext != nil) {
        return _parentManagedObjectContext;
    }
    
    NSManagedObjectContext *parentContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    parentContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    
    _parentManagedObjectContext = parentContext;
    return parentContext;
}

- (NSManagedObjectContext *)childManagedObjectContext {
    if (_childManagedObjectContext != nil) {
        return _childManagedObjectContext;
    }
    
    NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    childContext.parentContext = self.parentManagedObjectContext;
    
    _childManagedObjectContext = childContext;
    return childContext;
}

#pragma mark - Save data

- (void)saveData {
    if (!self.parentManagedObjectContext.hasChanges && !self.childManagedObjectContext.hasChanges) {
        return;
    }
    
    [self.childManagedObjectContext performBlockAndWait:^{
        NSError *childSaveError;
        BOOL isChildSaveSuccessful = [self.childManagedObjectContext save:&childSaveError];

        if (!isChildSaveSuccessful) {
            NSLog(@"CHILD CONTEXT SAVE ERROR: %@", childSaveError);
        }
    }];
    
    [self.parentManagedObjectContext performBlock:^{
        NSError *parentSaveError;
        BOOL isParentSaveSuccessful = [self.parentManagedObjectContext save:&parentSaveError];
        
        if (!isParentSaveSuccessful) {
            NSLog(@"PARENT CONTEXT SAVE ERROR: %@", parentSaveError);
        }
    }];
}

#pragma mark - Private methods for internal use

- (NSString *)convertStoreTypeToString:(RIStoreType)storeType {
    NSString *result;
    
    switch (storeType) {
        case RISQLiteStoreType:
            result = NSSQLiteStoreType;
            break;
            
        case RIBinaryStoreType:
            result = NSBinaryStoreType;
            break;

        case RIInMemoryStoreType:
            result = NSInMemoryStoreType;
            break;
            
        default:
            break;
    }
    
    return result;
}

#pragma mark - Initializers

- (instancetype)initWithMomdName:(NSString *)momdName {
    self = [super init];
    
    if (self) {
        self.momdName = momdName;
    }
    
    return self;
}

@end
