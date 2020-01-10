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
#import "RIReminderTableViewCell.h"
#import "RIReminder.h"
#import "RILockScreenViewController.h"

@interface RITasksListViewController ()

@property NSMutableArray<RIReminder *> *remindersArray;

@end

@implementation RITasksListViewController

#pragma mark -viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaultPropertyValues];
    
    [self setupNavigationBar];
    [self setupTableView];
    
    [self shouldLock:YES];
}

#pragma mark Set default property values

- (void)setDefaultPropertyValues {
    self.remindersArray = [NSMutableArray new];
}

#pragma mark UI setup

- (void)setupNavigationBar {
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    UIBarButtonItem *composeIcon = [self makeComposeIcon];
    
    self.navigationItem.rightBarButtonItem = composeIcon;
}

- (UIBarButtonItem *)makeComposeIcon {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeButtonTapped)];
}

- (void)composeButtonTapped {
    UINavigationController *navigationController = [RICreateReminderViewController instance];
    
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    RICreateReminderViewController *createReminderVc = (RICreateReminderViewController *)navigationController.viewControllers.firstObject;
    
    createReminderVc.delegate = self;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark Table view delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.remindersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RIReminderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: RIReminderTableViewCell.reuseIdentifier forIndexPath:indexPath];
    
    RIReminder *reminder = self.remindersArray[indexPath.row];
    
    cell.titleLabel.text = reminder.text;
    cell.dateLabel.text = reminder.date;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RIDetailViewController *detailVc = [RIDetailViewController instanceWithReminder:self.remindersArray[indexPath.row]];
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark CreateReminderViewControllerDelegate methods

- (void)didCreateReminder:(RIReminder *)newReminder {
    [self.remindersArray addObject:newReminder];
    
    [self.tableView reloadData];
}

//MOCK:
- (void)shouldLock:(BOOL)shouldLock {
    if (shouldLock) {
        [self presentViewController:[RILockScreenViewController instance] animated:NO completion:nil];
    }
}

@end
