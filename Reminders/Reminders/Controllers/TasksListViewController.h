//
//  TasksListViewController.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/20/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TasksListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

+ (TasksListViewController *)instance;

@end

