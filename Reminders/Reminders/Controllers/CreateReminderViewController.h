//
//  CreateReminderViewController.h
//  Reminders
//
//  Created by Ostap on 24.11.2019.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateReminderViewController.h"
#import "CreateReminderViewControllerDelegate.h"
#import "Reminder.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateReminderViewController : UIViewController

@property id <CreateReminderViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;

+ (CreateReminderViewController *)instance;

@end

NS_ASSUME_NONNULL_END
