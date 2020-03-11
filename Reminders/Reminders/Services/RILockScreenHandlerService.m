//
//  RILockScreenHandlerService.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 3/11/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RILockScreenHandlerService.h"
#import "RISecureManager.h"
#import "RILockScreenViewController.h"
#import "RIUIViewController+CurrentViewController.h"
#import "RIPasscodeEntryViewController.h"

@interface RILockScreenHandlerService ()

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) RILockScreenViewController *lockScreenVc;

@property (strong, nonatomic, readonly) RISecureManager *secureManager;

@end

@implementation RILockScreenHandlerService

#pragma mark - Property getters

- (RISecureManager *)secureManager {
    return RISecureManager.sharedInstance;
}

#pragma mark - Main methods

- (void)handleWillEnterForeground {
    [self.lockScreenVc setupLockScreenState];
}

- (void)handleDidEnterBackground {
    UIViewController *currentViewController = self.window.rootViewController.currentViewController;
    
    if (self.secureManager.isPasscodeSet) {
        if (self.lockScreenVc == nil) {
            self.lockScreenVc = [RILockScreenViewController instance];
        }
        
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

#pragma mark - Initializers

- (instancetype)initWithWindow:(UIWindow *)window {
    self = [super init];
    
    if (self) {
        self.window = window;
    }
    
    return self;
}

@end
