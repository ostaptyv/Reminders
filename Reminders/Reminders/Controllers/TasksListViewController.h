//
//  TasksListViewController.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/20/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateReminderViewControllerDelegate.h"

@interface TasksListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, CreateReminderViewControllerDelegate>

+ (TasksListViewController *)instance;

@end
