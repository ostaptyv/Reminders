//
//  RIAccessibilityConstants.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/20/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#pragma mark Accessibility identifiers


#pragma mark RITabBarController identifiers:
static NSString* const kTabBarSettingsButton = @"app.tabBarController.tabBar.settingsButton";

#pragma mark RISettingsViewController identifiers:
static NSString* const kSettingsBiometrySwitchIdentifier = @"app.settings.tableView.biometryCell.biometrySwitch";
static NSString* const kSettingsSetPasscodeCellIdentifier = @"app.settings.tableView.setPasscodeCell";

#pragma mark RILockScreenViewController identifiers:
static NSString* const kLockScreenIdentifier = @"app.lockScreen";
static NSString* const kLockScreenNotEnrolledBiometryAlertIdentifier = @"app.lockScreen.alert.biometryNotEnrolled";
static NSString* const kLockScreenNotEnrolledBiometryAlertOkActionIdentifier = @"app.lockScreen.alert.biometryNotEnrolled.action.ok";

#pragma mark RINumberPadButton identifiers:
static NSString* const kNumberPadButtonBiometryIdentifier = @"customUIElements.numberPadButton.biometry";

#pragma mark RINumberPad identifiers:
static NSString* const kNumberPadIdentifier = @"customUIElements.numberPad";
static NSString* const kNumberPadFallbackBiometryButtonIdentifier = @"customUIElements.numberPad.fallbackBiometryButton";
