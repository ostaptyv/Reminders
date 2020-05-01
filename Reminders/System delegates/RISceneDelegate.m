//
//  RISceneDelegate.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/20/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "RISceneDelegate.h"
#import "RIURLSchemeHandlerService.h"
#import "RICreateReminderHandlerService.h"
#import "RIConstants.h"
#import "RILockScreenHandlerService.h"

@interface RISceneDelegate ()

@property (strong, nonatomic, readonly) RILockScreenHandlerService *lockScreenHandlerService;
@property (strong, nonatomic, readwrite) RICreateReminderHandlerService *createReminderHandlerService;

@end

@implementation RISceneDelegate

#pragma mark - Property getters

@synthesize lockScreenHandlerService = _lockScreenHandlerService;

- (RILockScreenHandlerService *)lockScreenHandlerService {
    if (_lockScreenHandlerService == nil) {
        _lockScreenHandlerService = [[RILockScreenHandlerService alloc] initWithWindow:self.window];
    }
    
    return _lockScreenHandlerService;
}

#pragma mark - UISceneDelegate methods

- (void)sceneWillEnterForeground:(UIScene *)scene {
    [self.lockScreenHandlerService handleWillEnterForeground];
}

- (void)sceneDidEnterBackground:(UIScene *)scene {
    [self.lockScreenHandlerService handleDidEnterBackground];
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    RIURLSchemeHandlerService *urlSchemeHandlerService = [RIURLSchemeHandlerService new];
    UIOpenURLContext *urlContext = URLContexts.allObjects.firstObject;

    if (URLContexts.count > 1) {
        NSLog(@"WARNING: More than 1 UIOpenURLContext passed to URLContexts set; %s:%d", __FILE_NAME__, __LINE__);
    }
    
    RIReminderRaw *reminder = [urlSchemeHandlerService parseReminderSchemeURL:urlContext.URL];
    self.createReminderHandlerService = [[RICreateReminderHandlerService alloc] initWithRawReminder:reminder];
    
    [self registerForCreateReminderVcNotifications];
    [self.createReminderHandlerService manageViewControllersShowingBehavior];
}

#pragma mark - Register for create reminder VC notifications

- (void)registerForCreateReminderVcNotifications {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(cleanScreenHandlerServiceProperty:) name:RICreateReminderViewControllerDidCreateReminderNotification object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(cleanScreenHandlerServiceProperty:) name:RICreateReminderViewControllerDidPressAlertCancelNotification object:nil];
}

#pragma mark Private methods for internal purposes

- (void)cleanScreenHandlerServiceProperty:(NSNotification *)notification {
    self.createReminderHandlerService = nil;
}

@end
