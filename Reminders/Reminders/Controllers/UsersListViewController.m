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

@property NSMutableArray<User *> *usersArray;
@property NSArray<NSString *> *userNamesArray;

@property int countOfCellsInTableView;

@end

@implementation UsersListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.userNamesArray = @[@"Wade", @"Dave", @"Seth", @"Ivan", @"Riley", @"Gilbert", @"Jorge", @"Dan", @"Brian", @"Roberto", @"Ramon", @"Miles", @"Liam", @"Nathaniel", @"Ethan", @"Lewis", @"Milton", @"Claude", @"Joshua", @"Glen", @"Harvey", @"Blake", @"Antonio", @"Connor", @"Julian", @"Aidan", @"Harold", @"Conner", @"Peter", @"Hunter"];
    self.usersArray = [self makeUsersArrayWithCount:self.userNamesArray.count];
    
    self.countOfCellsInTableView = 2500;
    
    [self setupNavigationBar];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.countOfCellsInTableView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UsersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: UsersTableViewCell.reuseIdentifier forIndexPath:indexPath];
    
    User *user = self.usersArray[indexPath.row % self.usersArray.count];

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
    NSMutableArray<User *> *result = [NSMutableArray arrayWithCapacity:count];
   
    for (int i = 0; i < count; i++) {
        NSString *imageName = [NSString stringWithFormat:@"images-%i.jpeg", i + 1];
        UIImage *image = [UIImage imageNamed:imageName];

        [result addObject:[[User alloc] initWithName:self.userNamesArray[i] image:image]];
    }
    
    return result;
}

@end
