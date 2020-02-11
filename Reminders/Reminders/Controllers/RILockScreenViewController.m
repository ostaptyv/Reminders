//
//  RILockScreenViewController.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/19/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import "RILockScreenViewController.h"
#import "RIUIImage+ImageWithImageScaledToSize.h"
#import "RIDot.h"
#import "RIConstants.h"
#import "RIUIColor+Constants.h"
#import "RINSString+Constants.h"
#import "RISecureManager.h"
#import "RIError.h"
#import "RIUIImage+Constants.h"
#import "RISecureManagerError.h"

@interface RILockScreenViewController ()

@property (assign, nonatomic) CGFloat constraintValueForTouchIdModels;
@property (assign, nonatomic) CGFloat constraintValueForFaceIdModels;

@property (strong, nonatomic) NSMutableString *passcodeString;
@property (assign, nonatomic) NSUInteger passcodeCounter;

@property (strong, nonatomic) LAContext *biometryContext;

@end

@implementation RILockScreenViewController

#pragma mark Property getters

- (LAContext *)biometryContext {
    if (_biometryContext == nil) {
        _biometryContext = [LAContext new];
    }
    
    return _biometryContext;
}

#pragma mark Property setters

- (void)setPasscodeCounter:(NSUInteger)passcodeCounter {
    if (passcodeCounter < 0 || passcodeCounter > self.dotsControl.dotsCount) { return; }
    
    _passcodeCounter = passcodeCounter;
}

#pragma mark View did load method

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaultPropertyValues];
    
    [self setupBiometryContext:self.biometryContext];
    
    [self setupConstraintWhichCorrectsNumberPadPosition:self.constraintWhichCorrectsNumberPadPosition];
    [self setupNumberPad:self.numberPad];
    [self setupTitleLabel:self.titleLabel forBiometryType:self.biometryContext.biometryType];
    
    [self registerForSecureManagerNotifications];
}

#pragma mark View will appear method

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupSecureManagerSupport];
}

#pragma mark Creating instance

+ (RILockScreenViewController *)instance {
    NSString *stringClass = NSStringFromClass(self.class);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:stringClass bundle:nil];
    
    return [storyboard instantiateInitialViewController];
}

#pragma mark Set default property values

- (void)setDefaultPropertyValues {
    self.constraintValueForTouchIdModels = kConstraintValueForTouchIdModels;
    self.constraintValueForFaceIdModels = kConstraintValueForFaceIdModels;
    
    self.passcodeString = [NSMutableString new];
    self.passcodeCounter = 0;
}

#pragma mark Setup UI

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setupConstraintWhichCorrectsNumberPadPosition:(NSLayoutConstraint *)constraint {
    CGFloat constant;
    
    switch (self.biometryContext.biometryType) {
        case LABiometryTypeFaceID:
            constant = self.constraintValueForFaceIdModels;
            break;
            
        default:
            constant = self.constraintValueForTouchIdModels;
            break;
    }
    
    constraint.constant = constant;
    
    [self.view layoutIfNeeded];
}

- (void)setupNumberPad:(RINumberPad *)numberPad {
    UIImage *biometryIcon;
    UIColor *tintColor;
    
    switch (self.biometryContext.biometryType) {
        case LABiometryTypeTouchID:
            biometryIcon = UIImage.touchIdIcon;
            tintColor = UIColor.touchIdIconColor;
            break;
            
        case LABiometryTypeFaceID:
            biometryIcon = UIImage.faceIdIcon;
            tintColor = UIColor.faceIdIconColor;
            break;

        case LABiometryTypeNone:
            [numberPad hideBiometryButton];
            break;
    }
    
    numberPad.clearIcon = UIImage.clearIcon;;
    numberPad.biometryIcon = biometryIcon;
    
    numberPad.clearIconTintColor = UIColor.numberPadButtonColor;
    numberPad.biometryIconTintColor = tintColor;
    
    numberPad.delegate = self;
}

- (void)setupTitleLabel:(UILabel *)titleLabel forBiometryType:(LABiometryType)biometryType {
    NSString *stringBiometryType;
    
    switch (biometryType) {
        case LABiometryTypeTouchID:
            stringBiometryType = @"Touch ID or ";
            break;
            
        case LABiometryTypeFaceID:
            stringBiometryType = @"Face ID or ";
            break;
            
        case LABiometryTypeNone:
            stringBiometryType = @"";
            break;
    }
    
    titleLabel.text = [NSString stringWithFormat:@"%@Enter Passcode", stringBiometryType];
}

#pragma mark Setup biometric authentication

- (void)setupBiometryContext:(LAContext *)context {
    context.localizedFallbackTitle = kBiometryLocalizedFallbackTitle;
    
    [self checkPolicyAvailability]; // check 'canEvaluatePolicy' for the first time to make LAContext's 'biometryType' property up to date
}

- (BOOL)checkPolicyAvailability {
    NSError *error;
    
    BOOL canEvaluatePolicy = [self.biometryContext canEvaluatePolicy:kCurrentBiometryPolicy error:&error];
    
    if (!canEvaluatePolicy) {
        [self handleBiometryError:error];
    }
    
    return canEvaluatePolicy;
}

#pragma mark Number pad delegate methods

- (void)didPressButtonWithNumber:(NSUInteger)number {
    [self.dotsControl recolorDotsTo: ++self.passcodeCounter];
    
    [self.passcodeString appendFormat:@"%lu", number];
    
    if (self.passcodeCounter == self.dotsControl.dotsCount) {
        NSError *error;
        BOOL isPasscodeValid = [RISecureManager.shared validatePasscode:self.passcodeString withError:&error];

        [self handlePasscodeAuthentication:isPasscodeValid withError:error];
    }
}

- (void)didPressClearButton {
    [self.dotsControl recolorDotsTo: --self.passcodeCounter];
    
    if (self.passcodeString.length == 0) { return; }
    
    [self.passcodeString deleteCharactersInRange:NSMakeRange(self.passcodeString.length - 1, 1)];
}

- (void)didPressBiometryButton {
    [self instantiateBiometry];
}

#pragma mark Secure manager processing

- (void)setupSecureManagerSupport {
    if (RISecureManager.shared.isAppLockedOut) {
        UIAlertController *alert = [self makeAppDisableAlertForLockOutTime:RISecureManager.shared.lockOutTime];
        
        [self presentViewController:alert animated:NO completion:nil];
    }
    
    if (!RISecureManager.shared.isBiometryEnabled) {
        [self.numberPad hideBiometryButton];
    } else {
        [self.numberPad showBiometryButton];
    }
    
    [self setupLockScreenState];
}

- (void)setupLockScreenState {
    BOOL canEvaluatePolicy = [self checkPolicyAvailability];
    
    if (RISecureManager.shared.failedAttemptsCount >= 5 || !canEvaluatePolicy) {
        [self.numberPad disableBiometryButton];
    } else {
        [self.numberPad enableBiometryButton];
    }
}

- (void)registerForSecureManagerNotifications {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didSendPasscodeNotValidNotification:) name:RISecureManagerPasscodeNotValidNotification object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didSendAppLockOutAppliedNotification:) name:RISecureManagerAppLockOutAppliedNotification object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didSendAppLockOutReleasedNotification:) name:RISecureManagerAppLockOutReleasedNotification object:nil];
}

- (void)didSendPasscodeNotValidNotification:(NSNotification *)notification {
    NSNumber *failedAttemptsCount = notification.userInfo[kRISecureManagerFailedAttemptsCountKey];
    
    if (failedAttemptsCount.unsignedIntegerValue == 1) {
        [self changeTitleTextAnimatableWithString:@"Try Again"];
    }
}

- (void)didSendAppLockOutAppliedNotification:(NSNotification *)notification {
    NSNumber *lockOutTime = notification.userInfo[kRISecureManagerLockOutTimeKey];
    UIAlertController *disabledAlert = [self makeAppDisableAlertForLockOutTime:lockOutTime.unsignedIntegerValue];
    
    [self presentViewController:disabledAlert animated:YES completion:nil];
    
    [self.numberPad disableBiometryButton];
}

- (void)didSendAppLockOutReleasedNotification:(NSNotification *)notification {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Passcode processing

- (void)handlePasscodeAuthentication:(BOOL)isPasscodeValid withError:(NSError *)error {
    if (isPasscodeValid) {
        [self.biometryContext invalidate];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.dotsControl shakeControlWithHaptic:YES];
        [self.dotsControl recolorDotsTo:0];
        
        [self.passcodeString setString:@""];
        self.passcodeCounter = 0;
        
        [self handleSecureManagerError:error];
    }
}

#pragma mark Biometry proccessing

- (void)instantiateBiometry {
    BOOL canEvaluatePolicy = [self checkPolicyAvailability];
    
    if (!canEvaluatePolicy) { return; }
    
    NSString *localizedReason = [NSString biometryLocalizedReasonForBiometryType:self.biometryContext.biometryType];
        
    [self.biometryContext evaluatePolicy:kCurrentBiometryPolicy
                         localizedReason:localizedReason
                                   reply:^(BOOL success, NSError * _Nullable error) {
        
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        
        dispatch_async(mainQueue, ^{
            [self handleBiometryAuthenticationWithSuccess:success error:error];
        });
    }];
    
}

- (void)handleBiometryAuthenticationWithSuccess:(BOOL)success error:(NSError * _Nullable)error {
    if (success) {
        
        [self.biometryContext invalidate];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        
        [self handleBiometryError:error];
    }
}

#pragma mark Biometry errors handling

- (void)handleBiometryError:(NSError *)error {
    switch (error.code) {
        case LAErrorAuthenticationFailed:
            NSLog(@"TOO MANY ATTEMPTS");
            break;
            
        case LAErrorUserFallback:
            NSLog(@"FALLBACK USER");
            break;
            
        case LAErrorUserCancel:
            NSLog(@"CANCEL USER");
            break;
            
        case LAErrorBiometryLockout:
            NSLog(@"LOCKED OUT");
            [self.numberPad disableBiometryButton];
            break;
            
        case LAErrorBiometryNotEnrolled:
            [self handleBiometryNotEnrolledError];
            break;
            
        default:
            NSLog(@"BIOMETRY ERROR: %@", error);
            break;
    }
}

- (void)handleBiometryNotEnrolledError {
    NSString *title = [self makeNotEnrolledBiometryTitleForBiometryType:self.biometryContext.biometryType];
    NSString *message = [self makeNotEnrolledBiometryMessageForBiometryType:self.biometryContext.biometryType];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSString *)makeNotEnrolledBiometryTitleForBiometryType:(LABiometryType)biometryType {
    NSString *stringBiometryType;
    
    switch (biometryType) {
        case LABiometryTypeFaceID:
            stringBiometryType = @"Face ID";
            break;
            
        case LABiometryTypeTouchID:
            stringBiometryType = @"Touch ID";
            break;
            
        case LABiometryTypeNone:
            stringBiometryType = @"ERROR";
            break;
    }
    
    return [NSString stringWithFormat:@"Set up %@", stringBiometryType];
}

- (NSString *)makeNotEnrolledBiometryMessageForBiometryType:(LABiometryType)biometryType {
    NSString *stringBiometryType;
    NSString *stringAdviceForBiometry;
    
    switch (biometryType) {
        case LABiometryTypeFaceID:
            stringBiometryType = @"Face ID";
            stringAdviceForBiometry = @"face imprint";
            break;
            
        case LABiometryTypeTouchID:
            stringBiometryType = @"Touch ID";
            stringAdviceForBiometry = @"at least one fingerprint";
            break;
            
        case LABiometryTypeNone:
            stringBiometryType = @"ERROR";
            stringAdviceForBiometry = @"ERROR; CONTACT THE DEVELOPERS VIA ostap.reshaet.voprosiki@gmail.com";
            break;
    }
    
    return [NSString stringWithFormat:@"%@ is not setted up. Please go to: Settings -> %@ & Passcode, and create %@ to proceed.", stringBiometryType, stringBiometryType, stringAdviceForBiometry];
}

#pragma mark Secure manager errors handling

- (void)handleSecureManagerError:(NSError *)error {
    switch (error.code) {
        case RISecureManagerErrorValidationForbidden:
            NSLog(@"FATAL ERROR, CAN'T VALIDATE PASSCODE WHEN APP LOCKED OUT; REVIEW YOUR FUNCTIONALITY: %@", error);
            break;
            
        default:
            break;
    }
}

#pragma mark Private methods for internal purposes

- (void)changeTitleTextAnimatableWithString:(NSString *)string {
    [UIView transitionWithView:self.titleLabel
                      duration:kLockScreenTryAgainTitleAnimationDuration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
        
        self.titleLabel.text = string;
    } completion:nil];
}

- (NSString *)makeTryAgainStringForNumberOfSeconds:(double)numberOfSeconds {
    NSString *pluralSuffix = numberOfSeconds > 60.0 ? @"s" : @"";
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.roundingMode = NSNumberFormatterRoundHalfUp;
    
    NSString *stringNumber = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:(numberOfSeconds / 60.0)]];

    return [NSString stringWithFormat:@"Your app is disabled for %@ minute%@.", stringNumber, pluralSuffix];
}

- (UIAlertController *)makeAppDisableAlertForLockOutTime:(double)lockOutTime {
    NSString *titleString = [self makeTryAgainStringForNumberOfSeconds:lockOutTime];
    
    return [UIAlertController alertControllerWithTitle:titleString message:nil preferredStyle:UIAlertControllerStyleAlert];
}

@end
