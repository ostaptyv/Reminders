//
//  RICreateReminderHandlerService.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 3/10/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RICreateReminderHandlerService.h"
#import "RITasksListViewController.h"
#import "RICreateReminderViewController.h"
#import "RIConstants.h"
#import "RIReminderRaw.h"

@interface RICreateReminderHandlerService ()

@property (strong, nonatomic) RIReminderRaw *reminder;

@property (strong, nonatomic) RITasksListViewController *tasksListVc;
@property (strong, nonatomic) RICreateReminderViewController *oldCreateReminderVc;

@end

@implementation RICreateReminderHandlerService

#pragma mark - Manage UIViewControllers' showing behavior

- (void)manageViewControllersShowingBehavior {
    self.tasksListVc = [self retrieveTasksListVc];
    self.oldCreateReminderVc = [self retrieveCreateReminderVcUsing:self.tasksListVc];
    
    if (self.oldCreateReminderVc != nil) {
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didPressAlertProceedNotification:) name:RICreateReminderViewControllerDidPressAlertProceedNotification object:self.oldCreateReminderVc];
        [self.oldCreateReminderVc cancelReminderCreation];
    } else {

        RICreateReminderViewController *createReminderVc = [RICreateReminderViewController instance];
        UINavigationController *wrappedNewCreateReminderVc = [[UINavigationController alloc] initWithRootViewController:createReminderVc];
        wrappedNewCreateReminderVc.modalPresentationStyle = UIModalPresentationFullScreen;
        
        __typeof__(self) __weak weakSelf = self;
        [self.tasksListVc presentViewController:wrappedNewCreateReminderVc animated:YES completion:^{
            [weakSelf setupCreateReminderVc:createReminderVc withRawReminder:weakSelf.reminder];
        }];
    }
}

- (RITasksListViewController *)retrieveTasksListVc {
    UINavigationController *wrappedTasksListVc;
    
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes.allObjects) {
        if (![scene isKindOfClass:UIWindowScene.class]) {
            continue;
        }
        
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        
        UITabBarController *tabBarController = (UITabBarController *)windowScene.windows.firstObject.rootViewController;
        wrappedTasksListVc = (UINavigationController *)tabBarController.selectedViewController;
        
        break;
    }
    
    return (RITasksListViewController *)wrappedTasksListVc.viewControllers.firstObject;
}

- (RICreateReminderViewController *)retrieveCreateReminderVcUsing:(UIViewController *)parentVc {
    UINavigationController *navigationController = (UINavigationController *)parentVc.presentedViewController;
    RICreateReminderViewController *existingCreateReminderVc = (RICreateReminderViewController *)navigationController.viewControllers.firstObject;
    
    return existingCreateReminderVc;
}

#pragma mark - Create reminder VC notifications

- (void)didPressAlertProceedNotification:(NSNotification *)notification {
    [self.oldCreateReminderVc.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    
    RICreateReminderViewController *createReminderVc = [RICreateReminderViewController instance];
    UINavigationController *wrappedNewCreateReminderVc = [[UINavigationController alloc] initWithRootViewController:createReminderVc];
    wrappedNewCreateReminderVc.modalPresentationStyle = UIModalPresentationFullScreen;
    
    __typeof__(self) __weak weakSelf = self;
    [self.tasksListVc presentViewController:wrappedNewCreateReminderVc animated:YES completion:^{
        [weakSelf setupCreateReminderVc:createReminderVc withRawReminder:weakSelf.reminder];
    }];
}

#pragma mark - Private methods for internal purposes

- (void)setupCreateReminderVc:(RICreateReminderViewController *)createReminderVc withRawReminder:(RIReminderRaw *)rawReminder {
    createReminderVc.textView.text = rawReminder.text;
    createReminderVc.arrayOfImages = [NSMutableArray arrayWithArray:rawReminder.arrayOfImages];
    
    [createReminderVc.collectionView reloadData];
}

#pragma mark Initializers

- (instancetype)initWithRawReminder:(RIReminderRaw *)rawReminder {
    self = [super init];
    
    if (self) {
        self.reminder = rawReminder;
    }
    
    return self;
}

@end
