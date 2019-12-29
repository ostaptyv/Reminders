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
static const CGFloat biometryIconSideSize = 44;

// constants below were gotten in experimental way; may change in case of changing the clear icon
static const CGFloat clearIconBackgroundLayerXMultiplier = 1.0 / 3.0;
static const CGFloat clearIconBackgroundLayerYMultiplier = 1.0 / 4.0;
static const CGFloat clearIconBackgroundLayerSizeMultiplier = 1.0 / 2.0;

static const CGFloat dotConstraintValue = 13;
static const CGFloat constraintValueForTouchIdModels = 50;
static const CGFloat constraintValueForFaceIdModels = 38;

static const LAPolicy currentBiometryPolicy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
