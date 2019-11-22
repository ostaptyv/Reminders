//
//  TasksListViewController.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/20/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "TasksListViewController.h"

@interface TasksListViewController ()

@end

@implementation TasksListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

+ (TasksListViewController *)instance {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"TasksListViewController" bundle: nil];
    return [storyboard instantiateInitialViewController];
}

@end
