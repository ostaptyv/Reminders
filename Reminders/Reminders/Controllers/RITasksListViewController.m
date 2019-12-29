//
//  RITasksListViewController.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/20/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "RITasksListViewController.h"
#import "RICreateReminderViewController.h"
#import "RIDetailViewController.h"
#import "ReminderTableViewCell.h"
#import "RIReminder.h"
#import "RILockScreenViewController.h"

@interface RITasksListViewController ()

@end

@implementation RITasksListViewController

NSMutableArray<RIReminder *> *remindersArray;

#pragma mark -viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    remindersArray = [NSMutableArray new];
    
    [self setupNavigationBar];
    
    [self shouldLock:YES];
}

#pragma mark UITableView management

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return remindersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReminderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: ReminderTableViewCell.reuseIdentifier];
    
    RIReminder *reminder = remindersArray[indexPath.row];

    cell.titleLabel.text = reminder.text;
    cell.dateLabel.text = reminder.date;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RIDetailViewController *detailVc = [RIDetailViewController instanceWithReminder:remindersArray[indexPath.row]];

    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark UI setup

- (void)setupNavigationBar {
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    UIBarButtonItem *addIcon = [self makeAddIcon];
    
    self.navigationItem.rightBarButtonItems = @[addIcon];
}

- (UIBarButtonItem *)makeAddIcon {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped)];
}

- (void)addButtonTapped {
    RICreateReminderViewController *createReminderVc = [RICreateReminderViewController instance];
    
    createReminderVc.delegate = self;
    
    [self presentViewController:createReminderVc animated:YES completion:nil];
}

#pragma mark CreateReminderViewControllerDelegate methods

- (void)didCreateReminder:(RIReminder *)newReminder {
    [remindersArray addObject:newReminder];
    
    [self.tableView reloadData];
}

//MOCK:
- (void)shouldLock:(BOOL)shouldLock {
    if (shouldLock) {
        [self presentViewController:[RILockScreenViewController instance] animated:NO completion:nil];
    }
}

@end
