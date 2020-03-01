//
//  RILockScreenViewControllerUITests.m
//  RILockScreenViewControllerUITests
//
//  Created by Ostap Tyvonovych on 2/19/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RIConstants.h"
#import "RIAccessibilityConstants.h"
#import "RIBiometrics.h"
#import "RIUIImage+Constants.h"
#import <LocalAuthentication/LAContext.h>

@interface RILockScreenViewControllerUITests : XCTestCase

@property (strong, nonatomic) XCUIApplication *app;
@property (strong, nonatomic) XCUIApplication *springboard;

@end

@implementation RILockScreenViewControllerUITests

#pragma mark - Setuping and cleaning methods

- (void)setUp {
    [super setUp];
    
    self.continueAfterFailure = NO;
    
    self.app = [XCUIApplication new];
    self.springboard = [[XCUIApplication alloc] initWithBundleIdentifier:@"com.apple.springboard"];
    [self.app launch];
    
    [self.app.tabBars.buttons[kTabBarSettingsButton] tap];
    [self.app.tables.cells[kSettingsSetPasscodeCellIdentifier] tap];
    
    XCUIElement *key = self.app.keys[@"3"];
    
    for (int i = 0; i < 6; i++) {
        [key tap];
    }
    
    for (int i = 0; i < 6; i++) {
        [key tap];
    }
}

#pragma mark - Test cases



#pragma mark - Successful authentication case:

- (void)testAuthenticationSuccessful {
    RIBiometrics.isEnrolled = YES;
    
    XCUIElement *biometrySwitch = self.app.switches[kSettingsBiometrySwitchIdentifier];
    BOOL isSwitchExist = [biometrySwitch waitForExistenceWithTimeout:1.0];
    
    XCTAssertTrue(isSwitchExist, @"When passcode had been set 'Enable Touch ID' or 'Enable Face ID' switch wasn't shown, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    
    [biometrySwitch tap];
    
    [XCUIDevice.sharedDevice pressButton:XCUIDeviceButtonHome];
    [self.app activate];
    
    XCUIElement *lockScreenViewController = self.app.otherElements[kLockScreenIdentifier];
    BOOL isLockScreenExists = [lockScreenViewController waitForExistenceWithTimeout:1.0];
    
    XCTAssertTrue(isLockScreenExists, @"Each time when user quits the app (in developer's language – when app enters background) the app should lock. This test failed because lock screen hasn't been shown, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    
    XCUIElement *biometryButton = self.app.buttons[kNumberPadButtonBiometryIdentifier];
    BOOL isButtonExist = [self.app.buttons[kNumberPadButtonBiometryIdentifier] waitForExistenceWithTimeout:1.0];
    
    XCTAssertTrue(isButtonExist, @"Biometry button (with rather Face ID or Touch ID icon) isn't shown, which indicates unexpected behavior. Try to look through the test does it really toggle 'Enable Touch ID' or 'Enable Face ID' switch or try to review the functionality.");
    XCTAssertTrue(biometryButton.isEnabled, @"Biometry button (with rather Face ID or Touch ID icon) is shown, but in disabled state, which indicates undefined behavior. Try to look through the test does it really toggle 'Enable Touch ID' or 'Enable Face ID' switch or try to review the functionality.");
    
    [biometryButton tap];
    
    LAPolicy policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    LABiometryType biometryType = [self getBiometryTypeForPolicy:policy];
    XCUIElement *biometryAlertCompoundElement; // there's no possibility to straight detect biometry alert, so existence some of its compounds will mean existence of the whole alert
    NSPredicate *predicate;
    
    switch (biometryType) {
        case LABiometryTypeFaceID:
            predicate = [NSPredicate predicateWithFormat:@"label CONTAINS 'Face ID'"];
            biometryAlertCompoundElement = [self.springboard.images matchingPredicate:predicate].firstMatch; // in case of testing Touch ID 'biometryAlertCompoundElement' will contain static text from Touch ID alert
            break;
            
        case LABiometryTypeTouchID:
            predicate = [NSPredicate predicateWithFormat:@"label CONTAINS 'Touch ID'"];
            biometryAlertCompoundElement = [self.springboard.staticTexts matchingPredicate:predicate].firstMatch; // in case of testing Face ID 'biometryAlertCompoundElement' will contain image with label 'Face ID'
            break;
            
            
        case LABiometryTypeNone:
            XCTFail(@"Unexpected behavior; our deployment target doesn't suggest to include devices without biometrics. Try to look through the test or review the functionality.");
            break;
            
        default:
            XCTFail(@"Unexpected behavior; it seems like Apple added new biometry types. Try to look through the test and review the functionality.");
            break;
    }
    
    XCTAssertTrue([biometryAlertCompoundElement waitForExistenceWithTimeout:1.0], @"When hitting biometry button biometry alert hasn't been shown, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    
    [RIBiometrics authenticationSuccessfulForBiometryType:biometryType];
    
    XCTAssertFalse([biometryAlertCompoundElement waitForExistenceWithTimeout:1.0], @"When successful authentication have happened biometry alert hadn't been dissmissed, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    XCTAssertFalse([lockScreenViewController waitForExistenceWithTimeout:1.0], @"After successful biometry authentication the app should dismiss lock screen and let user interact with the app. This test failed because lock screen hasn't been dissmissed, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
}

#pragma mark - Unsuccessful authentication case and then choosing fallback authentication option:

- (void)testAuthenticationUnsuccessfulFallbackAction {
    RIBiometrics.isEnrolled = YES;
    
    XCUIElement *biometrySwitch = self.app.switches[kSettingsBiometrySwitchIdentifier];
    BOOL isSwitchExist = [biometrySwitch waitForExistenceWithTimeout:1.0];
    
    XCTAssertTrue(isSwitchExist, @"When passcode had been set 'Enable Touch ID' or 'Enable Face ID' switch wasn't shown, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    
    [biometrySwitch tap];
    
    [XCUIDevice.sharedDevice pressButton:XCUIDeviceButtonHome];
    [self.app activate];
    
    XCUIElement *lockScreenViewController = self.app.otherElements[kLockScreenIdentifier];
    BOOL isLockScreenExists = [lockScreenViewController waitForExistenceWithTimeout:1.0];
    
    XCTAssertTrue(isLockScreenExists, @"Each time when user quits the app (in developer's language – when app enters background) the app should lock. This test failed because lock screen hasn't been shown, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    
    
    XCUIElement *biometryButton = self.app.buttons[kNumberPadButtonBiometryIdentifier];
    BOOL isButtonExist = [self.app.buttons[kNumberPadButtonBiometryIdentifier] waitForExistenceWithTimeout:1.0];

    XCTAssertTrue(isButtonExist, @"Biometry button (with rather Face ID or Touch ID icon) isn't shown, which indicates unexpected behavior. Try to look through the test does it really toggle 'Enable Touch ID' or 'Enable Face ID' switch or try to review the functionality.");
    XCTAssertTrue(biometryButton.isEnabled, @"Biometry button (with rather Face ID or Touch ID icon) is shown, but in disabled state, which indicates undefined behavior. Try to look through the test does it really toggle 'Enable Touch ID' or 'Enable Face ID' switch or try to review the functionality.");
    
    [biometryButton tap];
    
    LAPolicy policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    LABiometryType biometryType = [self getBiometryTypeForPolicy:policy];
    XCUIElement *biometryAlertCompoundElement; // there's no possibility to straight detect biometry alert, so existence some of its compounds will mean existence of the whole alert
    NSPredicate *predicate;
    
    switch (biometryType) {
        case LABiometryTypeFaceID:
            predicate = [NSPredicate predicateWithFormat:@"label CONTAINS 'Face ID'"];
            biometryAlertCompoundElement = [self.springboard.images matchingPredicate:predicate].firstMatch; // in case of testing Touch ID 'biometryAlertCompoundElement' will contain static text from Touch ID alert
            break;

        case LABiometryTypeTouchID:
            predicate = [NSPredicate predicateWithFormat:@"label CONTAINS 'Touch ID'"];
            biometryAlertCompoundElement = [self.springboard.staticTexts matchingPredicate:predicate].firstMatch; // in case of testing Face ID 'biometryAlertCompoundElement' will contain image with label 'Face ID'
            break;
            
            
        case LABiometryTypeNone:
            XCTFail(@"Unexpected behavior; our deployment target doesn't suggest to include devices without biometrics. Try to look through the test or review the functionality.");
            break;
            
        default:
            XCTFail(@"Unexpected behavior; it seems like Apple added new biometry types. Try to look through the test and review the functionality.");
            break;
    }
    
    XCTAssertTrue([biometryAlertCompoundElement waitForExistenceWithTimeout:1.0], @"When hitting biometry button biometry alert hasn't been shown, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    
    [RIBiometrics authenticationUnsuccessfulForBiometryType:biometryType];
    
    switch (biometryType) {
        case LABiometryTypeFaceID: {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"label CONTAINS 'Face ID'"];
            XCUIElement *tryFaceIdAgainButton = [self.springboard.buttons containingPredicate:predicate].firstMatch;
            BOOL isTryFaceIdAgainButtonExist = [tryFaceIdAgainButton waitForExistenceWithTimeout:1.0];
            
            XCTAssertTrue(isTryFaceIdAgainButtonExist, @"When Face ID authentication hadn't been successful, 'Try Face ID Again' button wasn't shown, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
            
            [tryFaceIdAgainButton tap];
            
            [RIBiometrics authenticationUnsuccessfulForBiometryType:biometryType];
        }
            break;
            
        case LABiometryTypeTouchID:
            break;
            
        case LABiometryTypeNone:
            XCTFail(@"Unexpected behavior; our deployment target doesn't suggest to include devices without biometrics. Try to look through the test or review the functionality.");
            break;
        
        default:
            XCTFail(@"Unexpected behavior; it seems like Apple added new biometry types. Try to look through the test and review the functionality.");
            break;
    }
    
    XCUIElement *fallbackButton = self.springboard.buttons[kBiometryLocalizedFallbackTitle];
    BOOL isFallbackButtonExist = [fallbackButton waitForExistenceWithTimeout:1.0];
    
    XCTAssertTrue(isFallbackButtonExist, @"When authentication hadn't been successful fallback button wasn't shown, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    
    [fallbackButton tap];
    
    XCTAssertFalse([biometryAlertCompoundElement waitForExistenceWithTimeout:1.0], @"When hitting fallabck button have happened biometry alert hadn't been dissmissed, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    
    XCTAssertTrue([lockScreenViewController waitForExistenceWithTimeout:1.0], @"Since authentication has been unsuccessful, lock screen shouldn't be dissmissed. This test failed because of opposite. Try to look through the test, contact Apple developers or try to review the functionality.");
}

#pragma mark - Unsuccessful authentication case and then choosing cancel option:

- (void)testAuthenticationUnsuccessfulCancelAction {
    RIBiometrics.isEnrolled = YES;
    
    XCUIElement *biometrySwitch = self.app.switches[kSettingsBiometrySwitchIdentifier];
    BOOL isSwitchExist = [biometrySwitch waitForExistenceWithTimeout:1.0];
    
    XCTAssertTrue(isSwitchExist, @"When passcode had been set 'Enable Touch ID' or 'Enable Face ID' switch wasn't shown, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    
    [biometrySwitch tap];
    
    [XCUIDevice.sharedDevice pressButton:XCUIDeviceButtonHome];
    [self.app activate];
    
    XCUIElement *lockScreenViewController = self.app.otherElements[kLockScreenIdentifier];
    BOOL isLockScreenExists = [lockScreenViewController waitForExistenceWithTimeout:1.0];
    
    XCTAssertTrue(isLockScreenExists, @"Each time when user quits the app (in developer's language – when app enters background) the app should lock. This test failed because lock screen hasn't been shown, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    
    XCUIElement *biometryButton = self.app.buttons[kNumberPadButtonBiometryIdentifier];
    BOOL isButtonExist = [self.app.buttons[kNumberPadButtonBiometryIdentifier] waitForExistenceWithTimeout:1.0];
    
    XCTAssertTrue(isButtonExist, @"Biometry button (with rather Face ID or Touch ID icon) isn't shown, which indicates unexpected behavior. Try to look through the test does it really toggle 'Enable Touch ID' or 'Enable Face ID' switch or try to review the functionality.");
    XCTAssertTrue(biometryButton.isEnabled, @"Biometry button (with rather Face ID or Touch ID icon) is shown, but in disabled state, which indicates undefined behavior. Try to look through the test does it really toggle 'Enable Touch ID' or 'Enable Face ID' switch or try to review the functionality.");
    
    [biometryButton tap];
    
    LAPolicy policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    LABiometryType biometryType = [self getBiometryTypeForPolicy:policy];
    XCUIElement *biometryAlertCompoundElement; // there's no possibility to straight detect biometry alert, so existence some of its compounds will mean existence of the whole alert
    NSPredicate *predicate;
    
    switch (biometryType) {
        case LABiometryTypeFaceID:
            predicate = [NSPredicate predicateWithFormat:@"label CONTAINS 'Face ID'"];
            biometryAlertCompoundElement = [self.springboard.images matchingPredicate:predicate].firstMatch; // in case of testing Touch ID 'biometryAlertCompoundElement' will contain static text from Touch ID alert
            break;

        case LABiometryTypeTouchID:
            predicate = [NSPredicate predicateWithFormat:@"label CONTAINS 'Touch ID'"];
            biometryAlertCompoundElement = [self.springboard.staticTexts matchingPredicate:predicate].firstMatch; // in case of testing Face ID 'biometryAlertCompoundElement' will contain image with label 'Face ID'
            break;
            
        case LABiometryTypeNone:
            XCTFail(@"Unexpected behavior; our deployment target doesn't suggest to include devices without biometrics. Try to look through the test or review the functionality.");
            break;
            
        default:
            XCTFail(@"Unexpected behavior; it seems like Apple added new biometry types. Try to look through the test and review the functionality.");
            break;
    }
    
    XCTAssertTrue([biometryAlertCompoundElement waitForExistenceWithTimeout:1.0], @"When hitting biometry button biometry alert hasn't been shown, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    
    [RIBiometrics authenticationUnsuccessfulForBiometryType:biometryType];
    
    switch (biometryType) {
        case LABiometryTypeFaceID:
        case LABiometryTypeTouchID:
            break;
            
        case LABiometryTypeNone:
            XCTFail(@"Unexpected behavior; our deployment target doesn't suggest to include devices without biometrics. Try to look through the test or review the functionality.");
            break;
            
        default:
            XCTFail(@"Unexpected behavior; it seems like Apple added new biometry types. Try to look through the test and review the functionality.");
            break;
    }
    
    XCUIElement *cancelButton = self.springboard.buttons[@"Cancel"];
    BOOL isCancelButtonExist = [cancelButton waitForExistenceWithTimeout:1.0];
    
    XCTAssertTrue(isCancelButtonExist, @"When authentication hadn't been successful fallback button wasn't shown, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    
    [cancelButton tap];
    
    XCTAssertFalse([biometryAlertCompoundElement waitForExistenceWithTimeout:1.0], @"When hitting fallabck button have happened biometry alert hadn't been dissmissed, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    
    XCTAssertTrue([lockScreenViewController waitForExistenceWithTimeout:1.0], @"Since authentication has been unsuccessful, lock screen shouldn't be dissmissed. This test failed because of opposite. Try to look through the test, contact Apple developers or try to review the functionality.");
}

#pragma mark - Biometry not enrolled case:

- (void)testBiometryNotEnrolled {
    RIBiometrics.isEnrolled = NO;
    
    XCUIElement *biometrySwitch = self.app.switches[kSettingsBiometrySwitchIdentifier];
    BOOL isSwitchExist = [biometrySwitch waitForExistenceWithTimeout:1.0];
    
    XCTAssertTrue(isSwitchExist, @"When passcode had been set 'Enable Touch ID' or 'Enable Face ID' switch wasn't shown, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    
    [biometrySwitch tap];
    
    [XCUIDevice.sharedDevice pressButton:XCUIDeviceButtonHome];
    [self.app activate];
    
    XCUIElement *lockScreenViewController = self.app.otherElements[kLockScreenIdentifier];
    BOOL isLockScreenExists = [lockScreenViewController waitForExistenceWithTimeout:1.0];
    
    XCTAssertTrue(isLockScreenExists, @"Each time when user quits the app (in developer's language – when app enters background) the app should lock. This test failed because lock screen hasn't been shown, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    
    XCUIElement *biometryButton = self.app.buttons[kNumberPadButtonBiometryIdentifier];
    BOOL isBiometryButtonExist = [biometryButton waitForExistenceWithTimeout:1.0];
    
    XCTAssertTrue(isBiometryButtonExist, @"User toggled 'Enable Touch ID' or 'Enable Face ID' switch (depends on the device), and biometry button hadn't been shown, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    XCTAssertFalse(biometryButton.isEnabled, @"User toggled 'Enable Touch ID' or 'Enable Face ID' switch (depends on the device), but since biometry not enrolled biometry button have to be in disabled state. This test failed because 'isEnabled' property returned 'NO' which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    
    XCUIElement *fallbackBiometryButton = self.app.buttons[kNumberPadFallbackBiometryButtonIdentifier];
    BOOL isFallbackBiometryButtonExist = [fallbackBiometryButton waitForExistenceWithTimeout:1.0];
    
    XCTAssertTrue(isFallbackBiometryButtonExist, @"User toggled 'Enable Touch ID' or 'Enable Face ID' switch (depends on the device), but since biometry not enrolled, we should show an alert with a descriptive message explaining this. Biometry button is in disabled state (because we mustn't allow user to use unenrolled biometry), and the fallback biometry button is used to receive tap events on disabled \"true\" biometry button. This test failed because the fallback biometry button doesn't exist, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    XCTAssertTrue(fallbackBiometryButton.isEnabled, @"User toggled 'Enable Touch ID' or 'Enable Face ID' switch (depends on the device), but since biometry not enrolled, we should show an alert with a descriptive message explaining this. Biometry button is in disabled state (because we mustn't allow user to use unenrolled biometry), and the fallback biometry button is used to receive tap events on disabled \"true\" biometry button. This test failed because the fallback biometry button is disabled, which indicates undefined behavior: we will not be able to receive tap events as it meant to be. Try to look through the test, contact Apple developers or try to review the functionality.");
    
    [fallbackBiometryButton tap];
    
    XCUIElement *notEnrolledAlert = self.app.alerts[kLockScreenNotEnrolledBiometryAlertIdentifier];
    XCUIElement *alertOkButton = notEnrolledAlert.scrollViews.otherElements.buttons[@"OK"];
    
    XCTAssertTrue([notEnrolledAlert waitForExistenceWithTimeout:1.0], @"When hitting biometry button biometry not enrolled alert isn't shown, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    XCTAssertTrue([alertOkButton waitForExistenceWithTimeout:1.0], @"When hitting biometry button biometry not enrolled alert is shown but \"OK\" button of this alert hasn't been shown, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    
    [alertOkButton tap];
    
    XCTAssertFalse([notEnrolledAlert waitForExistenceWithTimeout:1.0], @"When hitting \"OK\" button of biometry not enrolled alert the alert didn't dissmiss, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    XCTAssertFalse([alertOkButton waitForExistenceWithTimeout:1.0], @"When hitting \"OK\" button of biometry not enrolled alert the alert button didn't disappear, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    
    XCTAssertTrue([lockScreenViewController waitForExistenceWithTimeout:1.0], @"Since authentication hasn't been initiated at all, lock screen shouldn't be dissmissed. This test failed because of opposite. Try to look through the test, contact Apple developers or try to review the functionality.");
}

#pragma mark - Case when user haven't toggled 'Enable Touch ID/Face ID' switch:

- (void)testBiometrySwitchToggledOff {
    XCUIElement *biometrySwitch = self.app.switches[kSettingsBiometrySwitchIdentifier];
    BOOL isSwitchExist = [biometrySwitch waitForExistenceWithTimeout:1.0];
    
    XCTAssertTrue(isSwitchExist, @"When passcode had been set 'Enable Touch ID' or 'Enable Face ID' switch wasn't shown, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    
    [XCUIDevice.sharedDevice pressButton:XCUIDeviceButtonHome];
    [self.app activate];
    
    XCUIElement *lockScreenViewController = self.app.otherElements[kLockScreenIdentifier];
    BOOL isLockScreenExists = [lockScreenViewController waitForExistenceWithTimeout:1.0];
    
    XCTAssertTrue(isLockScreenExists, @"Each time when user quits the app (in developer's language – when app enters background) the app should lock. This test failed because lock screen hasn't been shown, which indicates undefined behavior. Try to look through the test, contact Apple developers or try to review the functionality.");
    
    XCUIElement *biometryButton = self.app.buttons[kNumberPadButtonBiometryIdentifier];
    BOOL isButtonExist = [biometryButton waitForExistenceWithTimeout:1.0];
    
    XCTAssertFalse(isButtonExist, @"Biometry button (with rather Face ID or Touch ID icon) is shown, which indicates unexpected behavior: we haven't toggled 'Enable Touch ID/Face ID' switch, so biometry button doesn't have to be shown. Try to look through the test or try to review the functionality.");
    
    XCTAssertTrue([lockScreenViewController waitForExistenceWithTimeout:1.0], @"Since authentication hasn't been initiated at all, lock screen shouldn't be dissmissed. This test failed because of opposite. Try to look through the test, contact Apple developers or try to review the functionality.");
}

#pragma mark - Private methods for internal purposes

- (LABiometryType)getBiometryTypeForPolicy:(LAPolicy)policy {
    LAContext *context = [LAContext new];
    
    [context canEvaluatePolicy:policy error:nil];
    
    LABiometryType result = context.biometryType;
    
    [context invalidate];
    
    return result;
}

@end
