//
//  CreateReminderViewController.m
//  Reminders
//
//  Created by Ostap on 24.11.2019.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "CreateReminderViewController.h"
#import "Reminder.h"

@interface CreateReminderViewController ()

@end

@implementation CreateReminderViewController

#pragma mark -viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];

    self.textView.showsVerticalScrollIndicator = NO;
    
    [self setupNavigationBar];
    
    [self.textView becomeFirstResponder];
}

#pragma mark UI setup

- (void)setupNavigationBar {
    UIBarButtonItem *doneIcon = [self makeDoneIcon];
    
    self.navigationItem.rightBarButtonItem = doneIcon;
}

- (UIBarButtonItem *)makeDoneIcon {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped)];
}

- (void)doneButtonTapped {
    if (![self.textView.text isEqual:@""]) {
        Reminder *newReminder = [Reminder reminderWithText:self.textView.text dateInstance:[NSDate dateWithTimeIntervalSinceNow:0.0]];
        
        [self.delegate didCreateReminder:newReminder];
    }
    
    [self dismissViewControllerAnimated:YES completion: nil];
}

#pragma mark VC creation method

+ (CreateReminderViewController *)instance {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CreateReminderViewController" bundle:nil];
    return [storyboard instantiateInitialViewController];
}

@end
