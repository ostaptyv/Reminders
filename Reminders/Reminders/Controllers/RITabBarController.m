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
    
    UINavigationController *tasksListVc = [RITasksListViewController instance];
    UINavigationController *settingsVc = [RISettingsViewController instance];
    
    tasksListVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Reminders" image:UIImage.listIcon tag:0];
    settingsVc.tabBarItem = [self makeSettingsTabBarItem];
    
    self.viewControllers = @[tasksListVc, settingsVc];
}

- (UITabBarItem *)makeSettingsTabBarItem {
    UITabBarItem *result = [[UITabBarItem alloc] initWithTitle:@"Settings" image:UIImage.settingsIcon tag:0];
    
    result.accessibilityIdentifier = kTabBarSettingsButton;
    
    return result;
}

@end
