//
//  RISettingsViewController.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/27/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RISettingsDataSource.h"
#import "RIPasscodeEntryDelegate.h"

@interface RISettingsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, RIPasscodeEntryDelegate>

@property (assign, atomic, readonly) BOOL isPasscodeSet;

@property (weak, atomic) id<RISettingsDataSource> dataSource;

+ (UINavigationController *)instance;

@end
