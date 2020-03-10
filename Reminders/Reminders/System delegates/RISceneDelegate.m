//
//  RISceneDelegate.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/20/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "RISceneDelegate.h"
#import "RITasksListViewController.h"
#import "RICreateReminderViewController.h"
#import "RIConstants.h"
#import "RIURLSchemeHandlerService.h"
#import "RISecureManager.h"
#import "RILockScreenViewController.h"
#import "RIUIViewController+CurrentViewController.h"
#import "RIPasscodeEntryViewController.h"
#import "RIReminderRaw.h"

@interface RISceneDelegate ()

@property (strong, nonatomic) RIReminderRaw *reminder;

@property (strong, nonatomic) RIURLSchemeHandlerService *urlSchemeHandlerService;

@property (strong, nonatomic) RITasksListViewController *tasksListVc;

@property (strong, nonatomic) UINavigationController *navigationControllerWithCreateReminderVc;

@property (strong, nonatomic) RICreateReminderViewController *existingCreateReminderVc;
@property (strong, nonatomic) RICreateReminderViewController *freshCreateReminderVc;
@property (weak, nonatomic) RILockScreenViewController *lockScreenVc;

@property (assign, nonatomic) BOOL shouldRaiseNewCreateReminderVc;

@property (strong, nonatomic, readonly) RISecureManager *secureManager;

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
    self.urlSchemeHandlerService = [RIURLSchemeHandlerService new];
    
    UIOpenURLContext *urlContext = URLContexts.allObjects.firstObject;

    if (URLContexts.count > 1) {
        NSLog(@"WARNING: More than 1 UIOpenURLContext passed to URLContexts set; %s:%d", __FILE_NAME__, __LINE__);
    }
    
    self.reminder = [self.urlSchemeHandlerService parseReminderSchemeURL:urlContext.URL];
    
    [self manageViewControllersShowingBehavior];
}

#pragma mark - Manage UIViewControllers' showing behavior

- (void)manageViewControllersShowingBehavior {
    self.tasksListVc = [self makeTasksListViewController];
    
    RICreateReminderViewController *createReminderVc = [RICreateReminderViewController instanceWithCompletionHandler:nil];
    self.navigationControllerWithCreateReminderVc = [[UINavigationController alloc] initWithRootViewController:createReminderVc];
    self.navigationControllerWithCreateReminderVc.modalPresentationStyle = UIModalPresentationFullScreen;
    
    self.existingCreateReminderVc = [self retrieveExistingCreateReminderVcUsing:self.tasksListVc];
    self.freshCreateReminderVc = [self makeFreshCreateReminderVcUsing:self.navigationControllerWithCreateReminderVc];
    
    if (self.existingCreateReminderVc != nil) {
        [self.existingCreateReminderVc cancelReminderCreationShowingAlert:YES];
        
        self.shouldRaiseNewCreateReminderVc = YES;
    } else {
        [self.tasksListVc presentViewController:self.navigationControllerWithCreateReminderVc animated:YES completion: ^{
            [self setupCreateReminderVc:self.freshCreateReminderVc withReminder:self.reminder];
        }];
        
        self.shouldRaiseNewCreateReminderVc = NO;
    }
}

#pragma mark - Factory methods

- (RITasksListViewController *)makeTasksListViewController {
    UINavigationController *tasksListVc;
    
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes.allObjects) {
        if (![scene isKindOfClass:UIWindowScene.class]) {
            continue;
        }
        
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        
        UITabBarController *tabBarController = (UITabBarController *)windowScene.windows.firstObject.rootViewController;
        tasksListVc = (UINavigationController *)tabBarController.selectedViewController;
        
        break;
    }
    
    return (RITasksListViewController *)tasksListVc.viewControllers.firstObject;
}

- (RICreateReminderViewController *)retrieveExistingCreateReminderVcUsing:(UIViewController *)parentVc {
    UINavigationController *navigationController = (UINavigationController *)parentVc.presentedViewController;
    
    RICreateReminderViewController *existingCreateReminderVc = (RICreateReminderViewController *)navigationController.viewControllers.firstObject;
    
    existingCreateReminderVc.showsAlertOnCancel = YES;
    existingCreateReminderVc.delegate = self;
    
    return existingCreateReminderVc;
}

- (RICreateReminderViewController *)makeFreshCreateReminderVcUsing:(UINavigationController *)navigationController {
    RICreateReminderViewController *freshCreateReminderVc = (RICreateReminderViewController *)navigationController.viewControllers.firstObject;
    
    freshCreateReminderVc.showsAlertOnCancel = YES;
    freshCreateReminderVc.delegate = self;
    
    return freshCreateReminderVc;
}

#pragma mark - Create reminder delegate methods

- (void)didCreateReminderWithResponse:(RIResponse *)response viewController:(UIViewController *)viewController {
    if (self.freshCreateReminderVc == viewController) {
        [self.tasksListVc createReminderUsingResponse:response];
    }
    
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didPressAlertProceedButtonOnParent:(UIViewController *)parentViewController {
    if (self.shouldRaiseNewCreateReminderVc) {
        if (self.existingCreateReminderVc == parentViewController) {
            [parentViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
        [self.tasksListVc presentViewController:self.navigationControllerWithCreateReminderVc animated:YES completion:^{
            [self setupCreateReminderVc:self.freshCreateReminderVc withReminder:self.reminder];
        }];
        
        self.shouldRaiseNewCreateReminderVc = NO;
    } else {
        [parentViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didPressAlertCancelButton {
    self.shouldRaiseNewCreateReminderVc = NO;
}

#pragma mark - Customizing create reminder VC with data retrieved from URL

- (void)setupCreateReminderVc:(RICreateReminderViewController *)createReminderVc withReminder:(RIReminderRaw *)reminder {
    createReminderVc.textView.text = reminder.text;
    createReminderVc.arrayOfImages = [[NSMutableArray alloc] initWithArray:reminder.arrayOfImages];
    
    [createReminderVc.collectionView reloadData];
}

@end
