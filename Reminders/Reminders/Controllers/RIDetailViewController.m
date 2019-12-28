//
//  RIDetailViewController.m
//  Reminders
//
//  Created by Ostap on 24.11.2019.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "RIDetailViewController.h"

@interface RIDetailViewController ()

@end

@implementation RIDetailViewController

#pragma mark -viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.editable = NO;

    self.textView.text = self.reminder.text;
}

#pragma mark VC creation method

+ (RIDetailViewController *)instanceWithReminder:(RIReminder *)reminder {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RIDetailViewController" bundle:nil];
    RIDetailViewController *detailVc = [storyboard instantiateInitialViewController];

    detailVc.reminder = reminder;
    
    return detailVc;
}

#pragma mark Lazy -setReminder:

- (void)setReminder:(RIReminder *)reminder {
    if (!self.reminder) {
        _reminder = reminder;
    }
}

@end
