//
//  RITasksListViewController.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/20/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RICreateReminderViewControllerDelegate.h"

@interface RITasksListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, RICreateReminderViewControllerDelegate>

@end
