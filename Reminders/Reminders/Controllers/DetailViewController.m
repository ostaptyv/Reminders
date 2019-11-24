//
//  DetailViewController.m
//  Reminders
//
//  Created by Ostap on 24.11.2019.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.editable = NO;

    self.textView.text = self.reminder.text;
}

+ (DetailViewController *)instanceWithReminder:(Reminder *)reminder {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DetailViewController" bundle:nil];
    DetailViewController *detailVc = [storyboard instantiateInitialViewController];

    detailVc.reminder = reminder;
    
    return detailVc;
}

- (void)setReminder:(Reminder *)reminder {
    if (!self.reminder) {
        _reminder = reminder;
    }
}

@end
