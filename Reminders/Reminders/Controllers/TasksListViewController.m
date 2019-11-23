//
//  TasksListViewController.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/20/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "TasksListViewController.h"
#import "ReminderTableViewCell.h"
#import "Reminder.h"

@interface TasksListViewController ()

@end

@implementation TasksListViewController

NSMutableArray *remindersArray;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    remindersArray = [NSMutableArray arrayWithArray:@[[Reminder reminderWithText:@"1111" dateInstance:[NSDate dateWithTimeIntervalSinceNow:0.0]], [Reminder reminderWithText:@"2222\n2222" dateInstance:[NSDate dateWithTimeIntervalSinceNow:10000.0]], [Reminder reminderWithText:@"3333\n3333\n3333" dateInstance:[NSDate dateWithTimeIntervalSinceNow:10000.0]]]];
}

+ (TasksListViewController *)instance {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TasksListViewController" bundle:nil];
    return [storyboard instantiateInitialViewController];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return remindersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReminderTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: ReminderTableViewCell.reuseIdentifier];
    
    Reminder *reminder = remindersArray[indexPath.row];

    cell.titleLabel.text = reminder.text;
    cell.dateLabel.text = reminder.date;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
