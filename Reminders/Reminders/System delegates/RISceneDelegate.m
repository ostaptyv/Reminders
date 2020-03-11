//
//  RISceneDelegate.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/20/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "RISceneDelegate.h"
#import "RILockScreenViewController.h"
#import "RISecureManager.h"
#import "RIUIViewController+CurrentViewController.h"
#import "RIURLSchemeHandlerService.h"
#import "RIPasscodeEntryViewController.h"
#import "RIScreenHandlerService.h"
#import "RIConstants.h"

@interface RISceneDelegate ()

@property (weak, nonatomic) RILockScreenViewController *lockScreenVc;

@property (strong, nonatomic, readonly) RISecureManager *secureManager;
@property (strong, nonatomic, readwrite) RIScreenHandlerService *screenHandlerService;

@end

@implementation RISceneDelegate

#pragma mark - Property getters

- (RISecureManager *)secureManager {
    return RISecureManager.sharedInstance;
}

#pragma mark - UISceneDelegate methods

- (void)sceneWillEnterForeground:(UIScene *)scene {
    [self.lockScreenVc setupLockScreenState];
}

- (void)sceneDidEnterBackground:(UIScene *)scene {
    UIViewController *currentViewController = self.window.rootViewController.currentViewController;
    
    if (self.secureManager.isPasscodeSet) {
        self.lockScreenVc = self.lockScreenVc == nil ? [RILockScreenViewController instance] : self.lockScreenVc;
        
        if (currentViewController != self.lockScreenVc && currentViewController.presentingViewController != self.lockScreenVc) {
            [currentViewController presentViewController:self.lockScreenVc animated:NO completion:nil];
        }
    }
    
    if ([currentViewController isKindOfClass:UIAlertController.class] && currentViewController.presentingViewController != self.lockScreenVc) {
        [currentViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    if ([currentViewController isKindOfClass:RIPasscodeEntryViewController.class]) {
        RIPasscodeEntryViewController *passcodeEntryVc = (RIPasscodeEntryViewController *)currentViewController;
        
        [passcodeEntryVc cleanStrategyInput];
        [passcodeEntryVc revertStrategyState];
    }
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    RIURLSchemeHandlerService *urlSchemeHandlerService = [RIURLSchemeHandlerService new];
    UIOpenURLContext *urlContext = URLContexts.allObjects.firstObject;

    if (URLContexts.count > 1) {
        NSLog(@"WARNING: More than 1 UIOpenURLContext passed to URLContexts set; %s:%d", __FILE_NAME__, __LINE__);
    }
    
    RIReminderRaw *reminder = [urlSchemeHandlerService parseReminderSchemeURL:urlContext.URL];
    self.screenHandlerService = [[RIScreenHandlerService alloc] initWithRawReminder:reminder];
    
    [self registerForCreateReminderVcNotifications];
    [self.screenHandlerService manageViewControllersShowingBehavior];
}

#pragma mark - Register for create reminder VC notifications

- (void)registerForCreateReminderVcNotifications {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(cleanScreenHandlerServiceProperty:) name:RICreateReminderViewControllerDidCreateReminderNotification object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(cleanScreenHandlerServiceProperty:) name:RICreateReminderViewControllerDidPressAlertCancelNotification object:nil];
}

#pragma mark Private methods for internal purposes

- (void)cleanScreenHandlerServiceProperty:(NSNotification *)notification {
    self.screenHandlerService = nil;
}

@end
