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

@implementation RITabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationController *tasksListVc = [RITasksListViewController instance];
    UINavigationController *settingsVc = [RISettingsViewController instance];
    tasksListVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Reminders" image:UIImage.listIcon tag:0];
    settingsVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:UIImage.settingsIcon tag:1];
    
    self.viewControllers = @[tasksListVc, settingsVc];
}

@end
