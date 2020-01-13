//
//  RIConstants.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/28/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LAContext.h>

#import "NSString+Constants.h"
#import "UIColor+Constants.h"

static const CGFloat defaultDotBorderWidth = 1.25;
static const CGFloat animationDuration = 0.35;

static const CGFloat clearIconWidth = 43.2;
static const CGFloat clearIconHeight = 34.6;
static const CGFloat biometryIconSideSize = 44.0;

// next 3 constants were gotten in experimental way; may change in case of changing the clear icon
static const CGFloat clearIconBackgroundLayerXMultiplier = 1.0 / 3.0;
static const CGFloat clearIconBackgroundLayerYMultiplier = 1.0 / 4.0;
static const CGFloat clearIconBackgroundLayerSizeMultiplier = 1.0 / 2.0;

static const CGFloat dotConstraintValue = 13.0;
static const CGFloat constraintValueForTouchIdModels = 50.0;
static const CGFloat constraintValueForFaceIdModels = 38.0;

static const LAPolicy currentBiometryPolicy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;

static const CGFloat scrollViewTopContentInset = 10.0;
static const CGFloat collectionViewSectionInset = 20.0;

static const CGFloat imageAttachmentCollectionViewCellCornerRadius = 15.0;

static const CGFloat removeAttachmentIconBackgroundLayerOriginMultiplier = 0.5 * (1.0 - (1.0 / 1.4142136)); // 1/2 * (1 - 1/√2)
static const CGFloat removeAttachmentIconBackgroundLayerSizeMultiplier = 1.0 / 1.4142136; // 1/√2
static const CGFloat removeAttachmentIconImageInset = 3.0; // specific for "removeIcon" icon; may be changed or unneeded in case of other icon

static const CGFloat detailVcTextViewTopAndBottomContentInset = 10.0;
static const CGFloat detailVcTextViewSideContentInset = 20.0;

static NSString* const touchIdIconName = @"touchIdIcon";
static NSString* const faceIdIconName = @"faceIdIcon";
static NSString* const clearIconName = @"delete.left.fill";
static NSString* const removeIconName = @"removeIcon";

static NSString* const touchIdIconHexColor = @"FF2D55";
static NSString* const faceIdIconHexColor = @"0091FF";
static NSString* const numberPadButtonHexColor = @"E3E5E6";

static NSString* const biometryLocalizedFallbackTitle = @"Enter passcode";

static NSString* const RIRemoveAttachmentButtonTappedNotification = @"RIRemoveAttachmentButtonTappedNotification";

static NSString* const createReminderErrorDomain = @"com.OstapTyvonovych.Reminder.RICreateReminderError";
