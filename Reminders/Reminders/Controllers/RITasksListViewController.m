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
#import "RIReminderRaw.h"
#import "RILockScreenViewController.h"
#import "RIResponse.h"
#import "RIError.h"
#import "RIConstants.h"
#import <CoreData/CoreData.h>
#import "RICoreDataStack.h"
#import "RIAppDelegate.h"
#import "RINSFileManager+ImageSaving.h"
#import <UIKit/UIView.h>

@interface RITasksListViewController ()

@property (strong, nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic, readonly) RICoreDataStack *coreDataStack;

@end

@implementation RITasksListViewController

@synthesize coreDataStack = _coreDataStack;
@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - Property getters

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:RIReminder.entityName];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return _fetchedResultsController;
}

- (RICoreDataStack *)coreDataStack {
    if (_coreDataStack == nil) {
        RIAppDelegate *appDelegate = (RIAppDelegate *)UIApplication.sharedApplication.delegate;
        _coreDataStack = appDelegate.coreDataStack;
    }
    
    return _coreDataStack;
}

#pragma mark - View did load method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    [self setupTableView];
    
    [NSFileManager.defaultManager createGlobalImageStoreDirectory];
    
    NSError *error;
    BOOL is = [self.fetchedResultsController performFetch:&error];
    
    if (!is) {
        NSLog(@"EERRIRIRIRIR: %@", error);
    }
}

#pragma mark - Creating instance

+ (UINavigationController *)instance {
    NSString *stringClass = NSStringFromClass(self.class);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:stringClass bundle:nil];
    UINavigationController *tasksListVc = [storyboard instantiateInitialViewController];
    
    return tasksListVc;
}

#pragma mark - UI setup

- (void)setupNavigationBar {
    UIBarButtonItem *composeIcon = [self makeComposeIcon];
    self.navigationItem.rightBarButtonItem = composeIcon;
}

- (UIBarButtonItem *)makeComposeIcon {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeButtonTapped)];
}

- (void)composeButtonTapped {
    __weak __typeof__(self) weakSelf = self;
    
    UINavigationController *navigationController = [RICreateReminderViewController instanceWithCompletionHandler:^(RIResponse *response, __weak UIViewController *viewController) {
        
        [weakSelf createReminderUsingResponse:response];
        
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    RICreateReminderViewController *createReminderVc = (RICreateReminderViewController *)navigationController.viewControllers.firstObject;
    createReminderVc.showsAlertOnCancel = YES;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - Table view delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RIReminderTableViewCell *cell = (RIReminderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RIReminderTableViewCell.reuseIdentifier forIndexPath:indexPath];

    RIReminder *reminder = (RIReminder *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.titleLabel.text = [reminder.text isEqualToString:@""] ? @"New Reminder" : reminder.text;
    cell.dateLabel.text = reminder.date;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RIReminder *reminder = (RIReminder *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    RIDetailViewController *detailVc = [RIDetailViewController instanceWithRawReminder:[reminder transformToRaw]];
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - Errors handling

- (void)handleCreateReminderError:(NSError *)error {
    switch (error.code) {
        case RIErrorCreateReminderEmptyContent:
            NSLog(@"EMPTY CONTENT: %@", error);
            break;
            
        case RIErrorCreateReminderUserCancel:
            NSLog(@"USER CANCEL: %@", error);            
            break;
    }
}
 
#pragma mark - Create reminder method

- (void)createReminderUsingResponse:(RIResponse *)response {
    if (!response.isSuccess) {
        [self handleCreateReminderError:response.error];
        return;
    }
    
    NSURL *localDirectoryUrl = [NSFileManager.defaultManager createLocalImageStoreDirectory];
    RIReminderRaw *reminderRaw = [(RIReminderRaw *)response.result copy];
    NSMutableArray<NSString *> *arrayOfImagePaths = [NSMutableArray new];
    
    for (UIImage *image in reminderRaw.arrayOfImages) {
        NSData *pngData = UIImagePNGRepresentation(image);
        NSURL *imageUrl = [NSFileManager.defaultManager createImageFileForURL:localDirectoryUrl contents:pngData];
        NSString *imagePath = [self makePathStringFromImageURL:imageUrl];
        
        [arrayOfImagePaths addObject:imagePath];
    }
    
    RIReminder *reminder = [[RIReminder alloc] initWithContext:self.coreDataStack.managedObjectContext];
    
    reminder.text = reminderRaw.text;
    reminder.date = reminderRaw.date;
    reminder.arrayOfImagePaths = [arrayOfImagePaths copy];
    NSLog(@"%@", NSUUID.UUID.UUIDString);
    [self.coreDataStack saveData];
    [self reloadData];
}

#pragma mark - Private methods for internal purposes

- (NSString *)makePathStringFromImageURL:(NSURL *)url {
    NSArray<NSString *> *pathComponents = url.pathComponents;
    
    if (pathComponents.count >= kTasksListNumberOfLastURLPathComponents) {
        NSRange range = NSMakeRange(pathComponents.count - kTasksListNumberOfLastURLPathComponents, kTasksListNumberOfLastURLPathComponents);
        pathComponents = [pathComponents subarrayWithRange:range];
    }
    
    return [pathComponents componentsJoinedByString:@"/"];
}

- (void)reloadData {
    NSError *error;
    BOOL isFetchSuccessful = [self.fetchedResultsController performFetch:&error];
    
    if (!isFetchSuccessful) {
        NSLog(@"FETCH CORE DATA ERROR: %@", error);
    }
    
    [self.tableView reloadData];
}

@end
