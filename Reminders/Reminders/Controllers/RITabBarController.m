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

@implementation RITabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationController *tasksListVc = [RITasksListViewController instance];
    UINavigationController *settingsVc = [RISettingsViewController instance];
    tasksListVc.tabBarItem = [self makeListTabBarItem];
    settingsVc.tabBarItem = [self makeSettingsTabBarItem];
    
    self.viewControllers = @[tasksListVc, settingsVc];
}

- (UITabBarItem *)makeListTabBarItem {
    NSString *listTitle = @"Reminders";
    UIImageSymbolConfiguration *listSymbolConfig = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightBold];
    UIImage *listImage = [UIImage systemImageNamed:kListIconName withConfiguration:listSymbolConfig];
    
    return [[UITabBarItem alloc] initWithTitle:listTitle image:listImage tag:0];
}

- (UITabBarItem *)makeSettingsTabBarItem {
    NSString *settingsTitle = @"Settings";
    UIImage *settingsImage = [UIImage imageNamed:kSettingsIconName];
    
    return [[UITabBarItem alloc] initWithTitle:settingsTitle image:settingsImage tag:1];
}

@end
