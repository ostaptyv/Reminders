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
#import "RIResponse.h"
#import "RICreateReminderError.h"

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
    RITasksListViewController __weak *weakSelf = self;
    
    UINavigationController *navigationController = [RICreateReminderViewController instanceWithCompletionHandler: ^(RIResponse *response)
                                                    
    {
        if (response.isSuccess) {
            RIReminder *newReminder = [response.reminder copy];
                        
            [weakSelf.remindersArray addObject:newReminder];

            [weakSelf.tableView reloadData];
        }
        
        else {
            [weakSelf handleCreateReminderError:response.error];
        }
    }];
    
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    
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
    
    cell.titleLabel.text = [reminder.text isEqualToString:@""] ? @"New Reminder" : reminder.text;
    cell.dateLabel.text = reminder.date;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RIDetailViewController *detailVc = [RIDetailViewController instanceWithReminder:self.remindersArray[indexPath.row]];
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

//MOCK:
- (void)shouldLock:(BOOL)shouldLock {
    if (shouldLock) {
        [self presentViewController:[RILockScreenViewController instance] animated:NO completion:nil];
    }
}

#pragma mark Errors handling

- (void)handleCreateReminderError:(NSError *)error {
    switch (error.code) {
        case RICreateReminderErrorEmptyContent:
            NSLog(@"EMPTY CONTENT: %@", error);
            
            break;
        case RICreateReminderErrorUserCancel:
            NSLog(@"USER CANCEL: %@", error);
            
            break;
    }
}

@end
