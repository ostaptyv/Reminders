//
//  RISettingsViewController.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/27/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RISettingsDataSource.h"

@interface RISettingsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (assign, atomic, getter=isPasscodeSet) BOOL passcodeSet;

@property (weak, atomic) id<RISettingsDataSource> dataSource;

+ (UINavigationController *)instance;

@end
