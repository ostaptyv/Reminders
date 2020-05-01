//
//  RITabBarController.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/27/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RITabBarController.h"
#import "RITasksListViewController.h"
#import "RISettingsViewController.h"
#import "RIConstants.h"
#import "RIUIImage+Constants.h"
#import "RIAccessibilityConstants.h"

@implementation RITabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationController *wrappedTasksListVc = [[UINavigationController alloc] initWithRootViewController:[RITasksListViewController instance]];
    UINavigationController *wrappedSettingsVc = [[UINavigationController alloc] initWithRootViewController:[RISettingsViewController instance]];
    
    wrappedTasksListVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Reminders" image:UIImage.listIcon tag:0];
    wrappedSettingsVc.tabBarItem = [self makeSettingsTabBarItem];
    
    self.viewControllers = @[wrappedTasksListVc, wrappedSettingsVc];
}

- (UITabBarItem *)makeSettingsTabBarItem {
    UITabBarItem *result = [[UITabBarItem alloc] initWithTitle:@"Settings" image:UIImage.settingsIcon tag:0];
    
    result.accessibilityIdentifier = kTabBarSettingsButton;
    
    return result;
}

@end
