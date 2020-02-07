//
//  RIConstants.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/28/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LAContext.h>

#import "RINSString+Constants.h"
#import "RIUIColor+Constants.h"

static const CGFloat kDefaultDotBorderWidth = 1.25;
static const CGFloat kOffAnimationDuration = 0.35;

static const CGFloat kClearIconWidth = 43.2;
static const CGFloat kClearIconHeight = 34.6;
static const CGFloat kBiometryIconSideSize = 44.0;

// next 3 constants were gotten in experimental way; may change in case of changing the clear icon
static const CGFloat kClearIconBackgroundLayerXMultiplier = 1.0 / 3.0;
static const CGFloat kClearIconBackgroundLayerYMultiplier = 1.0 / 4.0;
static const CGFloat kClearIconBackgroundLayerSizeMultiplier = 1.0 / 2.0;

static const CGFloat kConstraintValueForTouchIdModels = 50.0;
static const CGFloat kConstraintValueForFaceIdModels = 38.0;

static const LAPolicy kCurrentBiometryPolicy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;

static const CGFloat kScrollViewTopContentInset = 10.0;
static const CGFloat kScrollViewBottomContentInset = 8.0;
static const CGFloat kCollectionViewSectionInset = 20.0;

static const CGFloat kImageAttachmentCollectionViewCellCornerRadius = 15.0;

static const CGFloat kRemoveAttachmentIconBackgroundLayerOriginMultiplier = 0.5 * (1.0 - (1.0 / 1.4142136)); // 1/2 * (1 - 1/√2)
static const CGFloat kRemoveAttachmentIconBackgroundLayerSizeMultiplier = 1.0 / 1.4142136; // 1/√2
static const CGFloat kRemoveAttachmentIconImageInset = 3.0; // specific for "removeIcon" icon; may be changed or unneeded in case of other icon

static const CGFloat kDetailVcTextViewTopAndBottomContentInset = 10.0;
static const CGFloat kDetailVcTextViewSideContentInset = 20.0;

static const NSInteger kSettingsNumberOfSectionsForManagingNewPasscodeInterface = 1;
static const NSInteger kSettingsNumberOfSectionsForManagingExistingPasscodeInterfaceWithBiometry = 2;
static const NSInteger kSettingsNumberOfSectionsForManagingExistingPasscodeInterfaceWithoutBiometry = 1;
static const NSInteger kSettingsNumberOfRowsInConfiguringExistingPasscodeSection = 2;
static const NSInteger kSettingsNumberOfRowsInUseBiometrySection = 1;
static const NSInteger kSettingsNumberOfRowsInConfiguringNewPasscodeSection = 1;

static const CGFloat kPasscodeEntryDotBorderWidth = 1.25;

static const CGFloat kPasscodeEntryTryAgainTitleAnimationDuration = 0.35;
static const CGFloat kLockScreenTryAgainTitleAnimationDuration = 0.45;

static const CGFloat kLockScreenDisabledBiometryButtonAlphaValue = 0.75;

static NSString* const kTouchIdIconName = @"touchIdIcon";
static NSString* const kFaceIdIconName = @"faceIdIcon";
static NSString* const kSettingsIconName = @"settingsIcon";
static NSString* const kClearIconName = @"delete.left.fill";
static NSString* const kListIconName = @"list.dash";
static NSString* const kRemoveIconName = @"removeIcon";

static NSString* const kTouchIdIconHexColor = @"FF2D55";
static NSString* const kFaceIdIconHexColor = @"0091FF";
static NSString* const kNumberPadButtonHexColor = @"E3E5E6";

static NSString* const kBiometryLocalizedFallbackTitle = @"Enter passcode";

static NSString* const RIRemoveAttachmentButtonTappedNotification = @"RIRemoveAttachmentButtonTappedNotification";

static NSString* const kCreateReminderErrorDomain = @"com.OstapTyvonovych.Reminder.RIError";

static NSString* const kImageAttachmentsFileSystemPath = @"ImageAttachments";

static NSString* const kImagesArrayURLArgumentName = @"images";

static NSString* const kSettingsTableViewReuseIdentifier = @"RISettingsTableViewCellReuseIdentifier";
static NSString* const kSettingsConfiguringNewPasscodeHeader = @"Configuring passcode";
static NSString* const kSettingsConfiguringNewPasscodeFooter = @"When you set up an additional passcode, your reminders will lock each time the app enters background.\nNote: if you'll forget your passcode, all the reminders will be lost.";
static NSString* const kSettingsConfiguringExistingPasscodeHeader = kSettingsConfiguringNewPasscodeHeader;

static NSString* const kSettingsSetPasscodeButtonTitle = @"Set Passcode";
static NSString* const kSettingsChangePasscodeButtonTitle = @"Change Passcode";
static NSString* const kSettingsTurnPasscodeOffButtonTitle = @"Turn Passcode Off";

static NSString* const kPasscodeEntrySetNewPasscodeOptionNavigationBarTitle = @"Set Passcode";
static NSString* const kPasscodeEntryEnterPasscodeOptionNavigationBarTitle = @"Turn Passcode Off";
static NSString* const kPasscodeEntryChangePasscodeOptionNavigationBarTitle = @"Change Passcode";

static NSString* const kPasscodeEntrySetNewPasscodeOptionEnterTitleLabel = @"Enter a passcode";
static NSString* const kPasscodeEntrySetNewPasscodeOptionConfirmTitleLabel = @"Verify your passcode";

static NSString* const kPasscodeEntryEnterPasscodeOptionTitleLabel = @"Enter your passcode";

static NSString* const kPasscodeEntryChangePasscodeOptionOldPasscodeTitleLabel = @"Enter your old passcode";
static NSString* const kPasscodeEntryChangePasscodeOptionNewPasscodeTitleLabel = @"Enter your new passcode";
static NSString* const kPasscodeEntryChangePasscodeOptionVerifyPasscodeTitleLabel = @"Verify your new passcode";

static NSString* const kPasscodeEntryFailedAttemptText = @"Failed Passcode Attempt";

static NSString* const kTurnOffPasscodeAlertTitle = @"Turn Off Passcode?";

static NSString* const RISecureManagerFailedAttemptsCountResetNotification = @"RISecureManagerFailedAttemptsCountResetNotification";
static NSString* const RISecureManagerPasscodeNotValidNotification = @"RISecureManagerPasscodeNotValidNotification";
static NSString* const RISecureManagerAppLockOutAppliedNotification = @"RISecureManagerAppLockOutAppliedNotification";
static NSString* const RISecureManagerAppLockOutReleasedNotification = @"RISecureManagerAppLockOutReleasedNotification";
static NSString* const RISecureManagerDidSetPasscodeNotification = @"RISecureManagerDidSetPasscodeNotification";
static NSString* const RISecureManagerDidResetPasscodeNotification = @"RISecureManagerDidResetPasscodeNotification";

static NSString* const kRISecureManagerLockOutTimeKey = @"lockOutTime";
static NSString* const kRISecureManagerFailedAttemptsCountKey = @"failedAttemptsCount";

static NSString* const kChangePasscodeWeakPasscodeAlertTitle = @"This passcode can be easily guessed";
static NSString* const kChangePasscodeWeakPasscodeAlertDescription = @"This passcode will be used to protect your reminders";
