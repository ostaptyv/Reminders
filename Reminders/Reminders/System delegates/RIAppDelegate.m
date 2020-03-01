//
//  RIAppDelegate.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/20/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "RIAppDelegate.h"
#import "RIConstants.h"

@implementation RIAppDelegate

#pragma mark - Property getters

@synthesize coreDataStack = _coreDataStack;

- (RICoreDataStack *)coreDataStack {
    if (_coreDataStack == nil) {
        _coreDataStack = [[RICoreDataStack alloc] initWithMomdName:kCoreDataModelName];
    }
    
    return _coreDataStack;
}

#pragma mark - Delegate methods

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

@end
