//
//  RICreateReminderViewController.m
//  Reminders
//
//  Created by Ostap on 24.11.2019.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "RICreateReminderViewController.h"
#import "RIReminder.h"

@interface RICreateReminderViewController ()

@end

@implementation RICreateReminderViewController

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
        RIReminder *newReminder = [RIReminder reminderWithText:self.textView.text dateInstance:[NSDate dateWithTimeIntervalSinceNow:0.0]];
        
        [self.delegate didCreateReminder:newReminder];
    }
    
    [self dismissViewControllerAnimated:YES completion: nil];
}

#pragma mark VC creation method

+ (RICreateReminderViewController *)instance {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RICreateReminderViewController" bundle:nil];
    return [storyboard instantiateInitialViewController];
}

@end
