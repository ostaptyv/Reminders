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
#import "RIError.h"
#import "RIConstants.h"

@interface RITasksListViewController ()

@property (strong, atomic, nonnull) NSMutableArray<RIReminder *> *remindersArray;

@property (strong, nonatomic, nullable, readonly) NSURL *imageAttachmentsFileSystemUrl;

@end

@implementation RITasksListViewController

#pragma mark Property getters

- (NSURL *)imageAttachmentsFileSystemUrl {
    NSError *error;
    NSURL *destinationUrl = [NSFileManager.defaultManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    
    if (error != nil) {
        NSLog(@"DESTINATION URL ERROR: %@", error);
        return nil;
    }

    return [destinationUrl URLByAppendingPathComponent:kImageAttachmentsFileSystemPath];;
}

#pragma mark -viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaultPropertyValues];
    
    [self setupNavigationBar];
    [self setupTableView];
    
    [self createGlobalImageStoreDirectory];
}

#pragma mark Set default property values

- (void)setDefaultPropertyValues {
    self.remindersArray = [NSMutableArray new];
    
    __weak __typeof__(self) weakSelf = self;
    
    self.createReminderCompletionHandler = ^(RIResponse *response)
    {
        if (response.isSuccess) {
            RIReminder *newReminder = [(RIReminder *)response.result copy];
            
            NSURL *localDirectoryUrl = [weakSelf createLocalImageStoreDirectory];
            
            for (UIImage *image in newReminder.arrayOfImages) {
                NSURL *imageUrl = [weakSelf createImageFileForURL:localDirectoryUrl contents:UIImagePNGRepresentation(image)];

                [newReminder.arrayOfImageURLs addObject:imageUrl];
            }
            
            [weakSelf.remindersArray addObject:newReminder];

            [weakSelf.tableView reloadData];
        }
        
        else {
            [weakSelf handleCreateReminderError:response.error];
        }
    };
}

#pragma mark +instance

+ (UINavigationController *)instance {
    NSString *stringClass = NSStringFromClass(self.class);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:stringClass bundle:nil];
    UINavigationController *tasksListVc = [storyboard instantiateInitialViewController];
    
    return tasksListVc;
}

#pragma mark UI setup

- (void)setupNavigationBar {
    UIBarButtonItem *composeIcon = [self makeComposeIcon];
    self.navigationItem.rightBarButtonItem = composeIcon;
}

- (UIBarButtonItem *)makeComposeIcon {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeButtonTapped)];
}

- (void)composeButtonTapped {
    __weak __typeof__(self) weakSelf = self;
    
    UINavigationController *navigationController = [RICreateReminderViewController instanceWithCompletionHandler:^(RIResponse *response, __weak UIViewController *viewController)
    {
        weakSelf.createReminderCompletionHandler(response);
        
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

#pragma mark Table view delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.remindersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RIReminderTableViewCell *cell = (RIReminderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RIReminderTableViewCell.reuseIdentifier forIndexPath:indexPath];

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

#pragma mark Errors handling

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

#pragma mark File system managing

- (void)createGlobalImageStoreDirectory {
    NSError *error;
    
    BOOL isSuccess = [NSFileManager.defaultManager createDirectoryAtURL:self.imageAttachmentsFileSystemUrl withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (!isSuccess) {
        NSLog(@"GLOBAL IMAGE STORE ERROR: %@", error);
    }
}

- (NSURL *)createLocalImageStoreDirectory {
    NSError *error;
    
    NSURL *destinationUrl = [self.imageAttachmentsFileSystemUrl URLByAppendingPathComponent:NSUUID.UUID.UUIDString];
    
    BOOL isSuccess = [NSFileManager.defaultManager createDirectoryAtURL:destinationUrl withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (!isSuccess) {
        NSLog(@"LOCAL IMAGE STORE ERROR: %@", error);
        return nil;
    }
    
    return destinationUrl;
}

- (NSURL *)createImageFileForURL:(NSURL *)url contents:(NSData *)data {
    NSString *path = [NSString stringWithFormat:@"%@.%@", NSUUID.UUID.UUIDString, @"png"];
    NSURL *destinationUrl = [url URLByAppendingPathComponent:path];

    BOOL isSuccess = [NSFileManager.defaultManager createFileAtPath:destinationUrl.path contents:data attributes:nil];
    
    if (!isSuccess) {
        NSLog(@"CREATE IMAGE FILE ERROR: -createFileAtPath:contents:attributes: returned NO");
        return nil;
    }
    
    return destinationUrl;
}

- (void)cleanAllAttacments {
    for (RIReminder *reminder in self.remindersArray) {
        for (NSURL *url in reminder.arrayOfImageURLs) {
            NSError *error;
            
            BOOL isSuccess = [NSFileManager.defaultManager removeItemAtURL:url error:&error];

            if (!isSuccess) {
                NSLog(@"REMOVE FILE ERROR (reminder: %p, url: %p): %@)", reminder, url, error);
            }
        }
    }
}

#pragma mark +dealloc

- (void)dealloc {
//    Clean all the image attacments from ~/ImageAttachments directory when app quits, because between launches of the app there's no place where we can store URLs to the images, therefore it may lead to memory leaks on SSD
    [self cleanAllAttacments];
}

@end
