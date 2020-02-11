//
//  RISettingsViewController.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/27/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <LocalAuthentication/LAContext.h>
#import "RISettingsViewController.h"
#import "RIConstants.h"
#import "RIPasscodeEntryViewController.h"
#import "RISettingsCellType.h"
#import "RIError.h"
#import "RISecureManager.h"
#import "RIUIViewController+CurrentViewController.h"
#import "RISecureManagerError.h"

@interface RISettingsViewController ()

@property (assign, nonatomic, readwrite) BOOL isPasscodeSet;

@property (assign, nonatomic) LABiometryType biometryType;

@property (assign, nonatomic) BOOL shouldDrawSetPasscodeInterface;

@end

@implementation RISettingsViewController

#pragma mark Property getters

- (BOOL)shouldDrawSetPasscodeInterface {
    if (self.dataSource != nil) {
        return self.dataSource.isPasscodeSet;
    } else {
        return !self.isPasscodeSet;
    }
}

#pragma mark Property setters

- (void)setShouldDrawSetPasscodeInterface:(BOOL)shouldSetPasscode {
    self.isPasscodeSet = !shouldSetPasscode;
}

#pragma mark View did load method

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaultPropertyValues];
    
    [self setupNavigationBar];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:kSettingsTableViewReuseIdentifier];
    
    [self registerForSecureManagerNotifications];
}

#pragma mark Creating instance

+ (UINavigationController *)instance {
    NSString *stringClass = NSStringFromClass(self.class);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:stringClass bundle:nil];
    UINavigationController *settingsVc = [storyboard instantiateInitialViewController];
    
    return settingsVc;
}

#pragma mark Set default property values

- (void)setDefaultPropertyValues {
    self.biometryType = [self determineBiometryType];
}

#pragma mark Setup UI

- (void)setupNavigationBar {
    self.navigationItem.title = @"Settings";
}

#pragma mark Convert index path to cell type

- (RISettingsCellType)convertIndexPathToCellType:(NSIndexPath *)indexPath {
    if (self.shouldDrawSetPasscodeInterface) { return RISettingsCellTypeSetPasscodeButton; }
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    return RISettingsCellTypeChangePasscodeButton;
                    break;
                    
                case 1:
                    return RISettingsCellTypeTurnPasscodeOffButton;
                    break;
                    
                default:
                    return RISettingsCellTypeUnspecified;
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    return RISettingsCellTypeUseBiometrySwitchOption;
                    break;
                    
                default:
                    return RISettingsCellTypeUnspecified;
                    break;
            }
            break;
            
        default:
            return RISettingsCellTypeUnspecified;
            break;
    }
}

#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.shouldDrawSetPasscodeInterface) {
        
        if (self.biometryType != LABiometryTypeNone) {
            return kSettingsNumberOfSectionsForManagingExistingPasscodeInterfaceWithBiometry;
            
        } else {
            return kSettingsNumberOfSectionsForManagingExistingPasscodeInterfaceWithoutBiometry;
        }
    } else {
        return kSettingsNumberOfSectionsForManagingNewPasscodeInterface;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.shouldDrawSetPasscodeInterface) {
        switch (section) {
            case 0:
                return kSettingsNumberOfRowsInConfiguringExistingPasscodeSection;
                break;
                
            case 1:
                return kSettingsNumberOfRowsInUseBiometrySection;
                break;
                
            default:
                return 0; // error
                break;
        }
        
    } else {
        return kSettingsNumberOfRowsInConfiguringNewPasscodeSection;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!self.shouldDrawSetPasscodeInterface) {
        switch (section) {
            case 0:
                return kSettingsConfiguringPasscodeHeader;
                break;
                
            default:
                return @"";
                break;
        }
    } else {
        return kSettingsConfiguringPasscodeHeader;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (self.shouldDrawSetPasscodeInterface) {
        return kSettingsConfiguringNewPasscodeFooter;
    }
    
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingsTableViewReuseIdentifier forIndexPath:indexPath];
    
    RISettingsCellType cellType = [self convertIndexPathToCellType:indexPath];
    
    switch (cellType) {
        case RISettingsCellTypeSetPasscodeButton:
            [self setupSetPasscodeButtonWithCell:&cell];
            break;
            
        case RISettingsCellTypeChangePasscodeButton:
            [self setupChangePasscodeButtonWithCell:&cell];
            break;
            
        case RISettingsCellTypeTurnPasscodeOffButton:
            [self setupTurnPasscodeOffButtonWithCell:&cell];
            break;
            
        case RISettingsCellTypeUseBiometrySwitchOption:
            [self setupUseBiometrySwitchOptionWithCell:&cell forBiometryType:self.biometryType];
            break;
            
        default:
            NSLog(@"CELLTYPE: %li", cellType);
            break;
    }
    
    return cell;
}

#pragma mark Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RISettingsCellType cellType = [self convertIndexPathToCellType:indexPath];
    RIPasscodeEntryOption entryOption = [self makeEntryOptionUsingCellType:cellType];
    
    UINavigationController *navigationController = [RIPasscodeEntryViewController instanceWithEntryOption:entryOption];
    
    RIPasscodeEntryViewController *entryPasscodeVc = (RIPasscodeEntryViewController *)navigationController.viewControllers.firstObject;
    entryPasscodeVc.delegate = self;
    
    UIAlertController *turnOffPasscodeAlert = [self makeTurnOffPasscodeAlert];
    
    switch (cellType) {
        case RISettingsCellTypeSetPasscodeButton:
        case RISettingsCellTypeChangePasscodeButton:
            [self presentViewController:navigationController animated:YES completion:nil];
            break;
            
        case RISettingsCellTypeTurnPasscodeOffButton:
            [self presentViewController:turnOffPasscodeAlert animated:YES completion:nil];
            break;
        // MOCK:
        default:
            NSLog(@"CELLTYPE MOCK: %li", cellType);
            break;
    };
}

- (UIAlertController *)makeTurnOffPasscodeAlert {
    UIAlertController *result = [UIAlertController alertControllerWithTitle:kTurnOffPasscodeAlertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof__(result) weakResult = result;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self cancelButtonTappedOnTurnPasscodeOffAlert:weakResult];
    }];
    UIAlertAction *turnOffAction = [UIAlertAction actionWithTitle:@"Turn Off" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [weakResult dismissViewControllerAnimated:YES completion:nil];
        
        UINavigationController *navigationController = [RIPasscodeEntryViewController instanceWithEntryOption:RIEnterPasscodeOption];
        
        RIPasscodeEntryViewController *entryPasscodeVc = (RIPasscodeEntryViewController *)navigationController.viewControllers.firstObject;
        entryPasscodeVc.delegate = self;
        
        [self presentViewController:navigationController animated:YES completion:nil];
    }];
    
    [result addAction:cancelAction];
    [result addAction:turnOffAction];
    
    return result;
}

- (RIPasscodeEntryOption)makeEntryOptionUsingCellType:(RISettingsCellType)cellType {
    RIPasscodeEntryOption result;
    
    switch (cellType) {
        case RISettingsCellTypeSetPasscodeButton:
            result = RISetNewPasscodeOption;
            break;
            
        case RISettingsCellTypeTurnPasscodeOffButton:
            result = RIEnterPasscodeOption;
            break;
            
        case RISettingsCellTypeChangePasscodeButton:
            result = RIChangePasscodeOption;
            break;
            
        default:
            result = RIUnspecifiedOption;
            break;
    }
    
    return result;
}

- (void)cancelButtonTappedOnTurnPasscodeOffAlert:(UIAlertController *)alertController {
    [alertController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Passcode entry delegate methods

- (void)didReceiveEntryEventWithResponse:(RIResponse *)response forEntryOption:(RIPasscodeEntryOption)option {
    if (response.isSuccess) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    switch (option) {
        case RISetNewPasscodeOption:
            [self handleSetNewPasscodeEventWithError:response.error];
            break;
            
        case RIEnterPasscodeOption:
            [self handleEnterPasscodeEventWithError:response.error];
            break;
            
        case RIChangePasscodeOption:
            [self handleChangePasscodeEventWithError:response.error];
            break;
            
        default:
            NSLog(@"UNRECOGNISED ENTRY OPTION; ENUM CASE: %lu", option);
            break;
    }
}

- (void)handleSetNewPasscodeEventWithError:(NSError *)error {
    switch (error.code) {
        case RISecureManagerErrorPasscodeAlreadySet:
            NSLog(@"FATAL ERROR, PASSCODE ALREADY SET; REVIEW YOUR FUNCTIONALITY: %@", error);
            break;
            
        default:
            NSLog(@"SET NEW PASSCODE EVENT UNKNOWN ERROR: %@", error);
            break;
    }
}

- (void)handleEnterPasscodeEventWithError:(NSError *)error {
    NSLog(@"ENTER PASSCODE EVENT UNKNOWN ERROR: %@", error);
}

- (void)handleChangePasscodeEventWithError:(NSError *)error {
    switch (error.code) {
        case RISecureManagerErrorPasscodeNotSetToBeChanged:
            NSLog(@"FATAL ERROR, CAN'T CHANGE PASSCODE THAT DOESN'T EXIST; REVIEW YOUR FUNCTIONALITY: %@", error);
            break;
            
        case RISecureManagerErrorChangingToSamePasscode:
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
            break;
            
        default:
            NSLog(@"CHANGE PASSCODE EVENT UNKNOWN ERROR: %@", error);
            break;
    }
}

#pragma mark Setup cell's UI

- (LABiometryType)determineBiometryType {
    LAContext *biometryContext = [LAContext new];
    
    [biometryContext canEvaluatePolicy:kCurrentBiometryPolicy error:nil];
    
    LABiometryType result = biometryContext.biometryType;
    
    [biometryContext invalidate];
    
    return result;
}

- (void)setupSetPasscodeButtonWithCell:(UITableViewCell **)pointerToCell {
    UITableViewCell *cell = *pointerToCell;
    
    cell.textLabel.text = kSetPasscodeTitle;
    cell.textLabel.textColor = UIColor.linkColor;
}

- (void)setupChangePasscodeButtonWithCell:(UITableViewCell **)pointerToCell {
    UITableViewCell *cell = *pointerToCell;
    
    cell.textLabel.text = kChangePasscodeTitle;
    cell.textLabel.textColor = UIColor.linkColor;
}

- (void)setupTurnPasscodeOffButtonWithCell:(UITableViewCell **)pointerToCell {
    UITableViewCell *cell = *pointerToCell;
    
    cell.textLabel.text = kTurnPasscodeOffTitle;
    cell.textLabel.textColor = UIColor.linkColor;
}

- (void)setupUseBiometrySwitchOptionWithCell:(UITableViewCell **)pointerToCell forBiometryType:(LABiometryType)biometryType {
    UITableViewCell *cell = *pointerToCell;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [self makeBiometryTitleForBiometryType:biometryType];
    cell.accessoryView = [self makeBiometrySwitch];
}

- (NSString *)makeBiometryTitleForBiometryType:(LABiometryType)biometryType {
    NSString *titleAddition;
    
    switch (biometryType) {
        case LABiometryTypeFaceID:
            titleAddition = @"Face ID";
            break;

        case LABiometryTypeTouchID:
            titleAddition = @"Touch ID";
            break;
            
        case LABiometryTypeNone:
            return @"ERROR"; // error
    }
    
    return [NSString stringWithFormat:@"Use %@", titleAddition];
}

- (UISwitch *)makeBiometrySwitch {
    UISwitch *result = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    result.on = NO;
    [result addTarget:self action:@selector(biometrySwitchToggled:) forControlEvents:UIControlEventValueChanged];
    
    return result;
}

- (void)biometrySwitchToggled:(UISwitch *)sender {
    NSError *error;
    BOOL isOperationSuccessful = [RISecureManager.shared setBiometryEnabled:sender.isOn withError:&error];
    
    if (!isOperationSuccessful) {
        switch (error.code) {
            case RISecureManagerErrorPasscodeNotSetToEnableBiometry:
                NSLog(@"FATAL ERROR, COULDN'T ENABLE BIOMETRY SINCE PASSCODE NOT SET; REVIEW YOUR FUNCTIONALITY: %@", error);
                break;
                
            default:
                break;
        }
    }
}

#pragma mark Register for secure manager notifications

- (void)registerForSecureManagerNotifications {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didSetPasscodeWithNotification:) name:RISecureManagerDidSetPasscodeNotification object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didResetPasscodeWithNotification:) name:RISecureManagerDidResetPasscodeNotification object:nil];
}

#pragma mark Notifications handling

- (void)didSetPasscodeWithNotification:(NSNotification *)notification {
    self.shouldDrawSetPasscodeInterface = NO;
    
    [self.tableView reloadData];
}

- (void)didResetPasscodeWithNotification:(NSNotification *)notification {
    self.shouldDrawSetPasscodeInterface = YES;
    
    [self.tableView reloadData];
}

@end
