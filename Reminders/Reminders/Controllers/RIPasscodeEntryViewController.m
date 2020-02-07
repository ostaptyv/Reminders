//
//  RIPasscodeEntryViewController.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/29/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RIPasscodeEntryViewController.h"
#import "RIDotsControl.h"
#import "RIConstants.h"
#import "RIPasscodeStrategyProtocol.h"
#import "RISetNewPasscodeStrategy.h"
#import "RIEnterPasscodeStrategy.h"
#import "RIChangePasscodeStrategy.h"
#import "RISecureManager.h"

@interface RIPasscodeEntryViewController ()

@property (assign, atomic) RIPasscodeEntryOption entryOption;
@property (strong, atomic) id<RIPasscodeStrategyProtocol> strategy;

@end

@implementation RIPasscodeEntryViewController

#pragma mark -viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBarWithEntryOption:self.entryOption];
    [self setupDotsControl];
    
    [self handleEntryOption:self.entryOption];
}

#pragma mark -viewWillAppear:

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.passcodeEntryView.failedAttemptsCount = RISecureManager.shared.failedAttemptsCount;
    [self.passcodeEntryView becomeFirstResponder];
}

#pragma mark +instance

+ (UINavigationController *)instanceWithEntryOption:(RIPasscodeEntryOption)entryOption{
    NSString *stringClass = NSStringFromClass(self.class);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:stringClass bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateInitialViewController];
    RIPasscodeEntryViewController *passcodeEntryVc = navigationController.viewControllers.firstObject;
    
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    passcodeEntryVc.entryOption = entryOption;
    
    return entryOption == RIUnspecifiedOption ? nil : navigationController;
}

#pragma mark Setup UI

- (void)setupNavigationBarWithEntryOption:(RIPasscodeEntryOption)entryOption {
    UIBarButtonItem *cancelItem = [self makeCancelItem];
    NSString *navigationTitle;
    
    switch (entryOption) {
        case RISetNewPasscodeOption:
            navigationTitle = kPasscodeEntrySetNewPasscodeOptionNavigationBarTitle;
            break;
            
        case RIEnterPasscodeOption:
            navigationTitle = kPasscodeEntryEnterPasscodeOptionNavigationBarTitle;
            break;
            
        case RIChangePasscodeOption:
            navigationTitle = kPasscodeEntryChangePasscodeOptionNavigationBarTitle;
            break;
            
        default:
            navigationTitle = @"nothing";
            break;
    }
    
    self.navigationItem.rightBarButtonItem = cancelItem;
    self.navigationItem.title = navigationTitle;
}

- (void)setupDotsControl {
    RIDotConfiguration *dotConfiguration = [[RIDotConfiguration alloc] initWithOffAnimationDuration:0.0 dotBorderWidth:kPasscodeEntryDotBorderWidth dotColor:UIColor.blackColor];
    
    self.passcodeEntryView.dotsControl.dotConfiguration = dotConfiguration;
}

- (UIBarButtonItem *)makeCancelItem {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
}

#pragma mark Handle bar buttons taps

- (void)cancelButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Handle entry option

- (void)handleEntryOption:(RIPasscodeEntryOption)entryOption {
    __typeof__(self) __weak weakSelf = self;
    
    void (^responseBlock)(RIResponse *) = ^(RIResponse *response) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(didReceiveEntryEventWithResponse:forEntryOption:)]) {
            
            [weakSelf.delegate didReceiveEntryEventWithResponse:response forEntryOption:entryOption];
        }
    };
    
    switch (entryOption) {
        case RISetNewPasscodeOption:
            self.strategy = [[RISetNewPasscodeStrategy alloc] initWithPasscodeEntryView:self.passcodeEntryView responseBlock:responseBlock];
            break;
            
        case RIEnterPasscodeOption:
            self.strategy = [[RIEnterPasscodeStrategy alloc] initWithPasscodeEntryView:self.passcodeEntryView responseBlock:responseBlock];
            break;
            
        case RIChangePasscodeOption:
            self.strategy = [[RIChangePasscodeStrategy alloc] initWithPasscodeEntryView:self.passcodeEntryView responseBlock:responseBlock];
            break;
            
        default:
            break;
    }
    
    self.passcodeEntryView.delegate = self.strategy;
    
    [self.strategy execute];
}

@end
