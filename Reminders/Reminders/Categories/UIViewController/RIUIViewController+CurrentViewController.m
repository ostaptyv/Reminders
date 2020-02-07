//
//  RIUIViewController+CurrentViewController.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/6/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RIUIViewController+CurrentViewController.h"

@implementation UIViewController (CurrentViewController)

- (UIViewController *)currentViewController {
    if (self.presentedViewController != nil) {
        return self.presentedViewController.currentViewController;
    }
    
    if ([self isKindOfClass:UINavigationController.class]) {
        UINavigationController *navigationController = (UINavigationController *)self;
        
        return navigationController.visibleViewController.currentViewController == nil ? navigationController.visibleViewController.currentViewController : navigationController;
    }
    
    if ([self isKindOfClass:UITabBarController.class]) {
        UITabBarController *tabBarController = (UITabBarController *)self;
        
        return tabBarController.selectedViewController == nil ? tabBarController.selectedViewController.currentViewController : tabBarController;
    }
    
    return self;
}

@end
