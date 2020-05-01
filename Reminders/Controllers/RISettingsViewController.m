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
#import "RIAccessibilityConstants.h"

@interface RISettingsViewController ()

@property (assign, nonatomic) BOOL isPasscodeSet;

@property (assign, nonatomic) LABiometryType biometryType;

@property (assign, nonatomic) BOOL shouldDrawSetPasscodeInterface;

@property (strong, nonatomic, readonly) RISecureManager *secureManager;

@end

@implementation RISettingsViewController

#pragma mark - Property getters

- (BOOL)shouldDrawSetPasscodeInterface {
    if (self.dataSource != nil) {
        return self.dataSource.isPasscodeSet;
    } else {
        return !self.isPasscodeSet;
    }
}

- (RISecureManager *)secureManager {
    return RISecureManager.sharedInstance;
}

#pragma mark - Property setters

- (void)setShouldDrawSetPasscodeInterface:(BOOL)shouldSetPasscode {
    self.isPasscodeSet = !shouldSetPasscode;
}

#pragma mark - View did load method

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaultPropertyValues];
    
    [self setupNavigationBar];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:kSettingsTableViewReuseIdentifier];
    
    [self registerForSecureManagerNotifications];
}

#pragma mark - Creating instance

+ (RISettingsViewController *)instance {
    NSString *stringClass = NSStringFromClass(self.class);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:stringClass bundle:nil];
    
    return [storyboard instantiateInitialViewController];
}

#pragma mark - Set default property values

- (void)setDefaultPropertyValues {
    self.biometryType = [self determineBiometryType];
}

#pragma mark - Setup UI

- (void)setupNavigationBar {
    self.navigationItem.title = @"Settings";
}

#pragma mark - Convert index path to cell type

- (RISettingsCellType)convertIndexPathToCellType:(NSIndexPath *)indexPath {
    if (self.shouldDrawSetPasscodeInterface) {
        return RISettingsCellTypeSetPasscode;
    }
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    return RISettingsCellTypeChangePasscode;
                    break;
                    
                case 1:
                    return RISettingsCellTypeTurnPasscodeOff;
                    break;
                    
                default:
                    return RISettingsCellTypeUnspecified;
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    return RISettingsCellTypeUseBiometry;
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

#pragma mark - Table view data source methods

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
        case RISettingsCellTypeSetPasscode:
            [self setupSetPasscodeCell:&cell];
            break;
            
        case RISettingsCellTypeChangePasscode:
            [self setupChangePasscodeCell:&cell];
            break;
            
        case RISettingsCellTypeTurnPasscodeOff:
            [self setupTurnPasscodeOffCell:&cell];
            break;
            
        case RISettingsCellTypeUseBiometry:
            [self setupUseBiometryCell:&cell forBiometryType:self.biometryType];
            break;
            
        default:
            NSLog(@"CELLTYPE: %li", cellType);
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RISettingsCellType cellType = [self convertIndexPathToCellType:indexPath];
    RIPasscodeEntryOption entryOption = [self makeEntryOptionUsingCellType:cellType];
    
    UINavigationController *navigationController = [self makeWrappedEntryPasscodeVcForEntryOption:entryOption];
    
    UIAlertController *turnOffPasscodeAlert = [self makeTurnOffPasscodeAlert];
    
    switch (cellType) {
        case RISettingsCellTypeSetPasscode:
        case RISettingsCellTypeChangePasscode:
            [self presentViewController:navigationController animated:YES completion:nil];
            break;
            
        case RISettingsCellTypeTurnPasscodeOff:
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
        
        UINavigationController *navigationController = [self makeWrappedEntryPasscodeVcForEntryOption:RIEnterPasscodeOption];
        [self presentViewController:navigationController animated:YES completion:nil];
    }];
    
    [result addAction:cancelAction];
    [result addAction:turnOffAction];
    
    return result;
}

- (RIPasscodeEntryOption)makeEntryOptionUsingCellType:(RISettingsCellType)cellType {
    RIPasscodeEntryOption result;
    
    switch (cellType) {
        case RISettingsCellTypeSetPasscode:
            result = RISetNewPasscodeOption;
            break;
            
        case RISettingsCellTypeTurnPasscodeOff:
            result = RIEnterPasscodeOption;
            break;
            
        case RISettingsCellTypeChangePasscode:
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

#pragma mark - Passcode entry delegate methods

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
        case RISecureManagerErrorPasscodeNotSet:
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

#pragma mark - Setup cell's UI

- (LABiometryType)determineBiometryType {
    LAContext *biometryContext = [LAContext new];
    
    [biometryContext canEvaluatePolicy:kCurrentBiometryPolicy error:nil];
    
    LABiometryType result = biometryContext.biometryType;
    
    [biometryContext invalidate];
    
    return result;
}

- (void)setupSetPasscodeCell:(UITableViewCell **)pointerToCell {
    UITableViewCell *cell = *pointerToCell;
    
    cell.textLabel.text = kSetPasscodeTitle;
    cell.textLabel.textColor = UIColor.linkColor;
    cell.accessibilityIdentifier = kSettingsSetPasscodeCellIdentifier;
}

- (void)setupChangePasscodeCell:(UITableViewCell **)pointerToCell {
    UITableViewCell *cell = *pointerToCell;
    
    cell.textLabel.text = kChangePasscodeTitle;
    cell.textLabel.textColor = UIColor.linkColor;
}

- (void)setupTurnPasscodeOffCell:(UITableViewCell **)pointerToCell {
    UITableViewCell *cell = *pointerToCell;
    
    cell.textLabel.text = kTurnPasscodeOffTitle;
    cell.textLabel.textColor = UIColor.linkColor;
}

- (void)setupUseBiometryCell:(UITableViewCell **)pointerToCell forBiometryType:(LABiometryType)biometryType {
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
            return @"ERROR";
    }
    
    return [NSString stringWithFormat:@"Use %@", titleAddition];
}

- (UISwitch *)makeBiometrySwitch {
    UISwitch *result = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    result.on = NO;
    result.accessibilityIdentifier = kSettingsBiometrySwitchIdentifier;
    [result addTarget:self action:@selector(biometrySwitchToggled:) forControlEvents:UIControlEventValueChanged];
    
    return result;
}

- (void)biometrySwitchToggled:(UISwitch *)sender {
    NSError *error;
    BOOL isOperationSuccessful = [self.secureManager setBiometryEnabled:sender.isOn withError:&error];
    
    if (!isOperationSuccessful) {
        switch (error.code) {
            case RISecureManagerErrorPasscodeNotSet:
                NSLog(@"FATAL ERROR, COULDN'T ENABLE BIOMETRY SINCE PASSCODE NOT SET; REVIEW YOUR FUNCTIONALITY: %@", error);
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - Register for secure manager notifications

- (void)registerForSecureManagerNotifications {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didSetPasscodeWithNotification:) name:RISecureManagerDidSetPasscodeNotification object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didResetPasscodeWithNotification:) name:RISecureManagerDidResetPasscodeNotification object:nil];
}

#pragma mark - Notifications handling

- (void)didSetPasscodeWithNotification:(NSNotification *)notification {
    self.shouldDrawSetPasscodeInterface = NO;
    
    [self.tableView reloadData];
}

- (void)didResetPasscodeWithNotification:(NSNotification *)notification {
    self.shouldDrawSetPasscodeInterface = YES;
    
    [self.tableView reloadData];
}

#pragma mark Private methods for internal purposes

- (UINavigationController *)makeWrappedEntryPasscodeVcForEntryOption:(RIPasscodeEntryOption)entryOption {
    RIPasscodeEntryViewController *passcodeEntryVc = [RIPasscodeEntryViewController instanceWithEntryOption:entryOption];
    passcodeEntryVc.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:passcodeEntryVc];
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    return navigationController;
}

@end
