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
#import "RIAccessibilityConstants.h"
#import "RINumberPadConfiguration.h"

@interface RILockScreenViewController ()

@property (assign, nonatomic) CGFloat constraintValueForTouchIdModels;
@property (assign, nonatomic) CGFloat constraintValueForFaceIdModels;

@property (strong, nonatomic) NSMutableString *passcodeString;
@property (assign, nonatomic) NSUInteger passcodeCounter;

@property (strong, nonatomic) LAContext *biometryContext;

@property (strong, nonatomic, readonly) RISecureManager *secureManager;

@end

@implementation RILockScreenViewController

#pragma mark - Property getters

- (LAContext *)biometryContext {
    if (_biometryContext == nil) {
        _biometryContext = [LAContext new];
    }
    
    return _biometryContext;
}

- (RISecureManager *)secureManager {
    return RISecureManager.sharedInstance;
}

#pragma mark - Property setters

- (void)setPasscodeCounter:(NSUInteger)passcodeCounter {
    if (passcodeCounter < 0 || passcodeCounter > self.dotsControl.dotsCount) {
        return;
    }
    
    _passcodeCounter = passcodeCounter;
}

#pragma mark - View did load method

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaultPropertyValues];
    
    [self setupBiometryContext:self.biometryContext];
    
    [self setupConstraintWhichCorrectsNumberPadPosition:self.constraintWhichCorrectsNumberPadPosition];
    [self setupNumberPad:self.numberPad];
    [self setupTitleLabel:self.titleLabel forBiometryType:self.biometryContext.biometryType];
    
    [self registerForSecureManagerNotifications];
    
    self.view.accessibilityIdentifier = kLockScreenIdentifier;
}

#pragma mark - View will appear method

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupSecureManagerSupport];
}

#pragma mark - Creating instance

+ (RILockScreenViewController *)instance {
    NSString *stringClass = NSStringFromClass(self.class);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:stringClass bundle:nil];
    
    return [storyboard instantiateInitialViewController];
}

#pragma mark - Set default property values

- (void)setDefaultPropertyValues {
    self.constraintValueForTouchIdModels = kConstraintValueForTouchIdModels;
    self.constraintValueForFaceIdModels = kConstraintValueForFaceIdModels;
    
    self.passcodeString = [NSMutableString new];
    self.passcodeCounter = 0;
}

#pragma mark - Setup UI

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
            numberPad.biometryButtonHidden = YES;
            break;
    }
    
    numberPad.numberPadConfiguration = [self makeNumberPadConfigurationWithBiometryIcon:biometryIcon biometryIconTintColor:tintColor];
    numberPad.delegate = self;
    
    __typeof__(self) __weak weakSelf = self;
    numberPad.biometryFallbackActionBlock = ^{
        NSError *error;
        BOOL canEvaluatePolicy = [weakSelf.biometryContext canEvaluatePolicy:kCurrentBiometryPolicy error:&error];
        
        if (canEvaluatePolicy) {
            return;
        }
        if (error.code != LAErrorBiometryNotEnrolled) {
            return;
        }
        
        UIAlertController *notEnrolledAlert = [weakSelf makeNotEnrolledBiometryAlert];
        
        [weakSelf presentViewController:notEnrolledAlert animated:YES completion:nil];
    };
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

#pragma mark - Setup biometry authentication

- (void)setupBiometryContext:(LAContext *)context {
    context.localizedFallbackTitle = kBiometryLocalizedFallbackTitle;
    
    [context canEvaluatePolicy:kCurrentBiometryPolicy error:nil]; // check 'canEvaluatePolicy' for the first time to make LAContext's 'biometryType' property up to date
}

- (BOOL)checkPolicyAvailability {
    NSError *error;
    
    BOOL canEvaluatePolicy = [self.biometryContext canEvaluatePolicy:kCurrentBiometryPolicy error:&error];
    
    if (!canEvaluatePolicy) {
        [self handleBiometryError:error];
    }
    
    return canEvaluatePolicy;
}

#pragma mark - Number pad delegate methods

- (void)didPressButtonWithNumber:(NSUInteger)number {
    [self.dotsControl recolorDotsTo: ++self.passcodeCounter];
    
    [self.passcodeString appendFormat:@"%lu", number];
    
    if (self.passcodeCounter == self.dotsControl.dotsCount) {
        NSError *error;
        BOOL isPasscodeValid = [self.secureManager validatePasscode:self.passcodeString withError:&error];

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

#pragma mark - Secure manager processing

- (void)setupSecureManagerSupport {
    if (self.secureManager.isAppLockedOut) {
        UIAlertController *alert = [self makeAppDisableAlertForLockOutTime:self.secureManager.lockOutTime];
        
        [self presentViewController:alert animated:NO completion:nil];
    }
    
    if (!self.secureManager.isBiometryEnabled) {
        self.numberPad.biometryButtonHidden = YES;
    } else {
        self.numberPad.biometryButtonHidden = NO;
    }
    
    [self setupLockScreenState];
}

- (void)setupLockScreenState {
    NSError *error;
    BOOL canEvaluatePolicy = [self.biometryContext canEvaluatePolicy:kCurrentBiometryPolicy error:&error];
    
    if (self.secureManager.failedAttemptsCount >= 5 || !canEvaluatePolicy) {
        self.numberPad.biometryButtonEnabled = NO;
    } else {
        self.numberPad.biometryButtonEnabled = YES;
    }
}

- (void)registerForSecureManagerNotifications {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didSendAppLockOutAppliedNotification:) name:RISecureManagerAppLockOutAppliedNotification object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didSendAppLockOutReleasedNotification:) name:RISecureManagerAppLockOutReleasedNotification object:nil];
}

- (void)didSendAppLockOutAppliedNotification:(NSNotification *)notification {
    NSNumber *lockOutTime = notification.userInfo[kRISecureManagerLockOutTimeKey];
    UIAlertController *disabledAlert = [self makeAppDisableAlertForLockOutTime:lockOutTime.unsignedIntegerValue];
    
    [self presentViewController:disabledAlert animated:YES completion:nil];
    
    self.numberPad.biometryButtonEnabled = NO;
}

- (void)didSendAppLockOutReleasedNotification:(NSNotification *)notification {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Passcode processing

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

#pragma mark - Biometry proccessing

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

#pragma mark - Biometry errors handling

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
            self.numberPad.biometryButtonEnabled = NO;
            break;
            
        case LAErrorBiometryNotEnrolled:
            NSLog(@"NOT ENROLLED");
            break;
            
        default:
            NSLog(@"BIOMETRY ERROR: %@", error);
            break;
    }
}

- (UIAlertController *)makeNotEnrolledBiometryAlert {
    NSString *title = [self makeNotEnrolledBiometryTitleForBiometryType:self.biometryContext.biometryType];
    NSString *message = [self makeNotEnrolledBiometryMessageForBiometryType:self.biometryContext.biometryType];
    
    UIAlertController *result = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    result.view.accessibilityIdentifier = kLockScreenNotEnrolledBiometryAlertIdentifier;
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [result addAction:okAction];
    
    return result;
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
    
    return [NSString stringWithFormat:@"%@ is not set up. Please go to: Settings -> %@ & Passcode, and create %@ to proceed.", stringBiometryType, stringBiometryType, stringAdviceForBiometry];
}

#pragma mark - Secure manager errors handling

- (void)handleSecureManagerError:(NSError *)error {
    NSString *tryAgainString = @"Try Again";
    
    switch (error.code) {
        case RISecureManagerErrorPasscodeNotValid:
            if (![self.titleLabel.text isEqualToString:tryAgainString]) {
                [self changeTitleTextAnimatableWithString:tryAgainString];
            }
            break;
            
        case RISecureManagerErrorValidationForbidden:
            NSLog(@"FATAL ERROR, CAN'T VALIDATE PASSCODE WHEN APP LOCKED OUT; REVIEW YOUR FUNCTIONALITY: %@", error);
            break;
            
        default:
            break;
    }
}

#pragma mark - Private methods for internal purposes

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

- (RINumberPadConfiguration *)makeNumberPadConfigurationWithBiometryIcon:(UIImage *)biometryIcon biometryIconTintColor:(UIColor *)biometryIconTintColor {

    return [[RINumberPadConfiguration alloc] initWithClearIcon:UIImage.clearIcon
                                                  biometryIcon:biometryIcon
                                            clearIconTintColor:UIColor.numberPadButtonColor
                                         biometryIconTintColor:biometryIconTintColor];
}

@end
