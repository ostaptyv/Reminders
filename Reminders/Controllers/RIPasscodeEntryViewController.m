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
#import "RIUIColor+Constants.h"

@interface RIPasscodeEntryViewController ()

@property (assign, nonatomic) RIPasscodeEntryOption entryOption;
@property (strong, nonatomic) id<RIPasscodeStrategyProtocol> strategy;

@property (strong, nonatomic, readonly) RISecureManager *secureManager;

@end

@implementation RIPasscodeEntryViewController

#pragma mark - Property getters

- (RISecureManager *)secureManager {
    return RISecureManager.sharedInstance;
}

#pragma mark - View did load method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.passcodeEntryMainBackgroundColor;
    
    [self setupNavigationBarWithEntryOption:self.entryOption];
    [self setupDotsControl];
    
    self.passcodeEntryView.failedAttemptsCount = self.secureManager.failedAttemptsCount;
    [self handleEntryOption:self.entryOption];
}

#pragma mark - View will appear method

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.passcodeEntryView becomeFirstResponder];
}

#pragma mark - Creating instance

+ (RIPasscodeEntryViewController *)instanceWithEntryOption:(RIPasscodeEntryOption)entryOption{
    NSString *stringClass = NSStringFromClass(self.class);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:stringClass bundle:nil];
    RIPasscodeEntryViewController *passcodeEntryVc = [storyboard instantiateInitialViewController];
    
    passcodeEntryVc.entryOption = entryOption;
    
    return entryOption == RIUnspecifiedOption ? nil : passcodeEntryVc;
}

#pragma mark - Setup UI

- (void)setupNavigationBarWithEntryOption:(RIPasscodeEntryOption)entryOption {
    UIBarButtonItem *cancelItem = [self makeCancelItem];
    NSString *navigationTitle;
    
    switch (entryOption) {
        case RISetNewPasscodeOption:
            navigationTitle = kSetPasscodeTitle;
            break;
            
        case RIEnterPasscodeOption:
            navigationTitle = kTurnPasscodeOffTitle;
            break;
            
        case RIChangePasscodeOption:
            navigationTitle = kChangePasscodeTitle;
            break;
            
        default:
            navigationTitle = @"ERROR";
            break;
    }
    
    self.navigationItem.rightBarButtonItem = cancelItem;
    self.navigationItem.title = navigationTitle;
}

- (void)setupDotsControl {
    RIDotConfiguration *dotConfiguration = [[RIDotConfiguration alloc] initWithOffAnimationDuration:0.0 dotBorderWidth:kDefaultDotBorderWidth dotColor:UIColor.defaultDotColor];
    
    self.passcodeEntryView.dotsControl.dotConfiguration = dotConfiguration;
}

- (UIBarButtonItem *)makeCancelItem {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
}

#pragma mark - Handle buttons taps

- (void)cancelButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Handle entry option

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

- (void)cleanStrategyInput {
    [self.strategy cleanInput];
}
- (void)revertStrategyState {
    [self.strategy revertState];
}

@end
