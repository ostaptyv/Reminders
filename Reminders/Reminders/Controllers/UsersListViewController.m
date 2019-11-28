//
//  UsersListViewController.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/20/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UsersListViewController.h"
#import "UsersTableViewCell.h"
#import "User.h"

@interface UsersListViewController ()

@end

@implementation UsersListViewController

NSMutableArray<User *> *usersArray;
NSArray<NSString *> *userNamesArray;

int countOfCellsInTableView;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    userNamesArray = @[@"Wade", @"Dave", @"Seth", @"Ivan", @"Riley", @"Gilbert", @"Jorge", @"Dan", @"Brian", @"Roberto", @"Ramon", @"Miles", @"Liam", @"Nathaniel", @"Ethan", @"Lewis", @"Milton", @"Claude", @"Joshua", @"Glen", @"Harvey", @"Blake", @"Antonio", @"Connor", @"Julian", @"Aidan", @"Harold", @"Conner", @"Peter", @"Hunter"];
    usersArray = [self makeUsersArrayWithCount:userNamesArray.count];
    
    countOfCellsInTableView = 2500;
    
    [self setupNavigationBar];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return countOfCellsInTableView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UsersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: UsersTableViewCell.reuseIdentifier];
    
    User *user = usersArray[indexPath.row % usersArray.count];

    cell.nameLabel.text = user.name;
    cell.userImageView.image = user.image;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setupNavigationBar {
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}

- (NSMutableArray<User *> *)makeUsersArrayWithCount:(NSInteger)count {
    NSMutableArray<User *> *result = [NSMutableArray<User *> new];
   
    for (int i = 0; i < count; i++) {
        [result addObject:[User userWithName:userNamesArray[i] image:[UIImage imageNamed:[NSString stringWithFormat:@"images-%i.jpeg", i + 1]]]];
    }
    
    return result;
}

@end
