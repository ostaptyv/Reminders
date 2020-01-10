//
//  RIDetailViewController.m
//  Reminders
//
//  Created by Ostap on 24.11.2019.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "RIDetailViewController.h"
#import "RIConstants.h"

@interface RIDetailViewController ()

@end

@implementation RIDetailViewController

#pragma mark -viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupTextView];
}

#pragma mark +instanceWithReminder:

+ (RIDetailViewController *)instanceWithReminder:(RIReminder *)reminder {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RIDetailViewController" bundle:nil];
    RIDetailViewController *detailVc = [storyboard instantiateInitialViewController];

    detailVc.reminder = reminder;
    
    return detailVc;
}

#pragma mark Setup UI

- (void)setupNavigationBar {
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
}

- (void)setupTextView {
    self.textView.editable = NO;
    self.textView.contentInset = UIEdgeInsetsMake(detailVcTextViewTopAndBottomContentInset,
                                                  detailVcTextViewSideContentInset,
                                                  detailVcTextViewTopAndBottomContentInset,
                                                  detailVcTextViewSideContentInset);

    self.textView.text = self.reminder.text;
}

#pragma mark Lazy immutable setter for 'reminder' proeprty

- (void)setReminder:(RIReminder *)reminder {
    if (!self.reminder) {
        _reminder = reminder;
    }
}

@end
