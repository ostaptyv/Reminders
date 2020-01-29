//
//  RISettingsViewController.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/27/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RISettingsViewController.h"
#import "RIConstants.h"
#import <LocalAuthentication/LAContext.h>

typedef NS_ENUM(NSInteger, RISettingsCellType) {
    RISettingsCellTypeUnspecified = 0,
    RISettingsCellTypeSetPasscodeButton = 1,
    RISettingsCellTypeChangePasscodeButton = 2,
    RISettingsCellTypeTurnPasscodeOffButton = 3,
    RISettingsCellTypeUseBiometrySwitchOption = 4
};

@interface RISettingsViewController ()

@property (assign, atomic) LABiometryType biometryType;

@property (assign, nonatomic, readonly) BOOL shouldSetPasscode;

@end

@implementation RISettingsViewController

#pragma mark Property getters

- (BOOL)shouldSetPasscode {
    if (self.dataSource == nil) {
        return !self.isPasscodeSet;
    } else {
        return ![self.dataSource isPasscodeSet];
    }
}

#pragma mark -viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaultPropertyValues];
    
    [self setupNavigationBar];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:kSettingsTableViewReuseIdentifier];
}

#pragma mark +instance

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

#pragma mark -convertIndexPathToCellType

- (RISettingsCellType)convertIndexPathToCellType:(NSIndexPath *)indexPath {
    if (self.shouldSetPasscode) { return RISettingsCellTypeSetPasscodeButton; }
    
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
    if (!self.shouldSetPasscode) {
        
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
    if (!self.shouldSetPasscode) {
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
    if (!self.shouldSetPasscode) {
        switch (section) {
            case 0:
                return kSettingsConfiguringExistingPasscodeHeader;
                break;
                
            default:
                return @"";
                break;
        }
    } else {
        return kSettingsConfiguringNewPasscodeHeader;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (self.shouldSetPasscode) {
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
    
    switch (cellType) {
        // MOCK:
        case RISettingsCellTypeSetPasscodeButton:
            self.passcodeSet = YES;
            [self.tableView reloadData];
            break;
        // MOCK:
        default:
            NSLog(@"CELLTYPE MOCK: %li", cellType);
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
    
    cell.textLabel.text = kSettingsSetPasscodeButtonTitle;
    cell.textLabel.textColor = UIColor.linkColor;
}

- (void)setupChangePasscodeButtonWithCell:(UITableViewCell **)pointerToCell {
    UITableViewCell *cell = *pointerToCell;
    
    cell.textLabel.text = kSettingsChangePasscodeButtonTitle;
    cell.textLabel.textColor = UIColor.linkColor;
}

- (void)setupTurnPasscodeOffButtonWithCell:(UITableViewCell **)pointerToCell {
    UITableViewCell *cell = *pointerToCell;
    
    cell.textLabel.text = kSettingsTurnPasscodeOffButtonTitle;
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
    // MOCK:
    NSLog(@"BIOMETRY: %@", sender.isOn ? @"ON" : @"OFF");
}

@end
