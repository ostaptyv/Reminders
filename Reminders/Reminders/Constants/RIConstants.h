//
//  RIConstants.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/28/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <CoreGraphics/CGBase.h>
#import <LocalAuthentication/LAContext.h>

#pragma mark Configuring default UIDot appearance
static const CGFloat kDefaultDotBorderWidth = 1.25;
static const CGFloat kDefaultOffAnimationDuration = 0.35;

#pragma mark Configuring biometry and clear buttons of RINumberPad
static const CGFloat kClearIconWidth = 43.2;
static const CGFloat kClearIconHeight = 34.6;
static const CGFloat kBiometryIconSideSize = 44.0;

// next 3 constants were gotten in experimental way; may change in case of changing the clear icon
static const CGFloat kClearIconBackgroundLayerXMultiplier = 1.0 / 3.0;
static const CGFloat kClearIconBackgroundLayerYMultiplier = 1.0 / 4.0;
static const CGFloat kClearIconBackgroundLayerSizeMultiplier = 1.0 / 2.0;

static const CGFloat kConstraintValueForTouchIdModels = 50.0;
static const CGFloat kConstraintValueForFaceIdModels = 38.0;

static const CGFloat kLockScreenDisabledBiometryButtonAlphaValue = 0.75;

#pragma mark Actual biometry policy constant
static const LAPolicy kCurrentBiometryPolicy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;

#pragma mark Configuring displaying of reminder
static const CGFloat kScrollViewTopContentInset = 10.0;
static const CGFloat kScrollViewBottomContentInset = 8.0;
static const CGFloat kCollectionViewSectionInset = 20.0;

static const CGFloat kImageAttachmentCollectionViewCellCornerRadius = 15.0;

static const CGFloat kRemoveAttachmentIconBackgroundLayerOriginMultiplier = 0.14645; // 1/2 * (1 - 1/√2)
static const CGFloat kRemoveAttachmentIconBackgroundLayerSizeMultiplier = 0.707107; // 1/√2
static const CGFloat kRemoveAttachmentIconImageInset = 3.0; // specific for "removeIcon" icon; may be changed or unneeded in case of other icon

#pragma mark Settuping settings' UITableView rows and sections
static const NSInteger kSettingsNumberOfSectionsForManagingNewPasscodeInterface = 1;
static const NSInteger kSettingsNumberOfSectionsForManagingExistingPasscodeInterfaceWithBiometry = 2;
static const NSInteger kSettingsNumberOfSectionsForManagingExistingPasscodeInterfaceWithoutBiometry = 1;
static const NSInteger kSettingsNumberOfRowsInConfiguringExistingPasscodeSection = 2;
static const NSInteger kSettingsNumberOfRowsInUseBiometrySection = 1;
static const NSInteger kSettingsNumberOfRowsInConfiguringNewPasscodeSection = 1;

#pragma mark Animation durations
static const CGFloat kPasscodeEntryTryAgainTitleAnimationDuration = 0.35;
static const CGFloat kLockScreenTryAgainTitleAnimationDuration = 0.45;

#pragma mark Fallback title for biometry pop-up
static NSString* const kBiometryLocalizedFallbackTitle = @"Enter passcode";

#pragma mark RIImageAttachmentCollectionViewCell's event for remove attachment action
static NSString* const RIRemoveAttachmentButtonTappedNotification = @"RIRemoveAttachmentButtonTappedNotification";

#pragma mark Error domains names
static NSString* const kRIErrorDomain = @"com.OstapTyvonovych.Reminder.RIError";
static NSString* const kRISecureManagerErrorDomain = @"com.OstapTyvonovych.Reminder.RISecureManagerError";

#pragma mark Name of folder for storing reminders' images
static NSString* const kImageAttachmentsFileSystemPath = @"ImageAttachments";

#pragma mark URL-scheme's argument name for passing images
static NSString* const kImagesArrayURLArgumentName = @"images";

#pragma mark Settings' UITableView reuse identifier
static NSString* const kSettingsTableViewReuseIdentifier = @"RISettingsTableViewCellReuseIdentifier";

#pragma mark Settuping settings' UITableView texts
static NSString* const kSettingsConfiguringPasscodeHeader = @"Configuring passcode";
static NSString* const kSettingsConfiguringNewPasscodeFooter = @"When you set up an additional passcode, your reminders will lock each time the app enters background.\nNote: if you'll forget your passcode, all the reminders will be lost.";

static NSString* const kSetPasscodeTitle = @"Set Passcode";
static NSString* const kChangePasscodeTitle = @"Change Passcode";
static NSString* const kTurnPasscodeOffTitle = @"Turn Passcode Off";

#pragma mark Settuping passcode entry strategies
static NSString* const kPasscodeEntrySetNewPasscodeOptionEnterTitleLabel = @"Enter a passcode";
static NSString* const kPasscodeEntrySetNewPasscodeOptionConfirmTitleLabel = @"Verify your passcode";

static NSString* const kPasscodeEntryEnterPasscodeOptionTitleLabel = @"Enter your passcode";

static NSString* const kPasscodeEntryChangePasscodeOptionOldPasscodeTitleLabel = @"Enter your old passcode";
static NSString* const kPasscodeEntryChangePasscodeOptionNewPasscodeTitleLabel = @"Enter your new passcode";
static NSString* const kPasscodeEntryChangePasscodeOptionVerifyPasscodeTitleLabel = @"Verify your new passcode";

static NSString* const kPasscodeEntryFailedAttemptText = @"Failed Passcode Attempt";

static NSString* const kTurnOffPasscodeAlertTitle = @"Turn Off Passcode?";

static NSString* const kChangePasscodeWeakPasscodeAlertTitle = @"This passcode can be easily guessed";
static NSString* const kChangePasscodeWeakPasscodeAlertDescription = @"This passcode will be used to protect your reminders";

#pragma mark RISecureManager notifications
static NSString* const RISecureManagerAppLockOutAppliedNotification = @"RISecureManagerAppLockOutAppliedNotification";
static NSString* const RISecureManagerAppLockOutReleasedNotification = @"RISecureManagerAppLockOutReleasedNotification";
static NSString* const RISecureManagerDidSetPasscodeNotification = @"RISecureManagerDidSetPasscodeNotification";
static NSString* const RISecureManagerDidResetPasscodeNotification = @"RISecureManagerDidResetPasscodeNotification";

#pragma mark RISecureManager notifications' userInfo keys
static NSString* const kRISecureManagerLockOutTimeKey = @"lockOutTime";
static NSString* const kRISecureManagerFailedAttemptsCountKey = @"failedAttemptsCount";
