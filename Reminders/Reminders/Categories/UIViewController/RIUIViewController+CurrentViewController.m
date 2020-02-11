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
        
        return navigationController.visibleViewController.currentViewController != nil ? navigationController.visibleViewController.currentViewController : navigationController; // if there isn't any view controller in 'visibleViewController' property, it means that this navigation controller is the top view controller in the stack. That means that the method may also quit at this point, if 'navigationController.visibleViewController.currentViewController != nil' returns NO
    }
    
    if ([self isKindOfClass:UITabBarController.class]) {
        UITabBarController *tabBarController = (UITabBarController *)self;
        
        return tabBarController.selectedViewController != nil ? tabBarController.selectedViewController.currentViewController : tabBarController; // same situation as with UINavigationController
    }
    
    return self;
}

@end
