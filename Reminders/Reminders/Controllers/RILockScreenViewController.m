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
#import "UIImage+ImageWithImageScaledToSize.h"
#import "UIColor+HexInit.h"
#import "RIDot.h"
#import "RIConstants.h"

@interface RILockScreenViewController ()

@property CGFloat constraintValueForTouchIdModels;
@property CGFloat constraintValueForFaceIdModels;

@property NSMutableString *passcodeString;
@property (nonatomic) NSUInteger passcodeCounter;

//MOCK:
@property NSString *persistentStoragePasscodeString;

@property LAContext *biometryContext;

@end

@implementation RILockScreenViewController

#pragma mark -viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaultPropertyValues];
    
    [self setupBiometryContext:self.biometryContext];
    
    [self setupConstraintWhichCorrectsNumberPadPosition:self.constraintWhichCorrectsNumberPadPosition];
    [self setupNumberPad:self.numberPad];
    [self setupTitleLabel:self.titleLabel forBiometryType:self.biometryContext.biometryType];
    
    [self instantiateBiometry];
}

#pragma mark +instance

+ (RILockScreenViewController *)instance {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RILockScreenViewController" bundle:nil];
    return [storyboard instantiateInitialViewController];
}

#pragma mark Property setters

- (void)setPasscodeCounter:(NSUInteger)passcodeCounter {
    if (passcodeCounter < 0 || passcodeCounter > self.dotsControl.dotsCount) { return; }
    
    _passcodeCounter = passcodeCounter;
}

#pragma mark Set default property values

- (void)setDefaultPropertyValues {
    self.constraintValueForTouchIdModels = constraintValueForTouchIdModels;
    self.constraintValueForFaceIdModels = constraintValueForFaceIdModels;
    
    self.passcodeString = [NSMutableString new];
    self.passcodeCounter = 0;
    
//    MOCK:
    self.persistentStoragePasscodeString = @"123456"; // change here to change the passcode
    
    self.biometryContext = [LAContext new];
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
    UIImage *clearIcon = [UIImage systemImageNamed:clearIconName];
    UIImage *touchIdIcon = [UIImage imageNamed:touchIdIconName];
    UIImage *faceIdIcon = [UIImage imageNamed:faceIdIconName];

    UIImage *biometryIcon;
    NSString *tintColorHex;
    
    switch (self.biometryContext.biometryType) {
        case LABiometryTypeTouchID:
            biometryIcon = touchIdIcon;
            tintColorHex = touchIdIconHexColor;
            
            break;
        case LABiometryTypeFaceID:
            biometryIcon = faceIdIcon;
            tintColorHex = faceIdIconHexColor;

            break;
        case LABiometryTypeNone:
            [numberPad hideBiometryButton];
            
            break;
    }
    
    numberPad.clearIcon = clearIcon;
    numberPad.biometryIcon = biometryIcon;
    
    numberPad.clearIconTintColor = [[UIColor alloc] initWithHex:numberPadButtonHexColor];
    numberPad.biometryIconTintColor = [[UIColor alloc] initWithHex:tintColorHex];
    
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
    context.localizedFallbackTitle = biometryLocalizedFallbackTitle;
    
    [self checkPolicyAvailability]; // check 'canEvaluatePolicy' for the first time to make 'biometryType' property up to date
}

- (BOOL)checkPolicyAvailability {
    NSError *error;
    
    BOOL canEvaluatePolicy = [self.biometryContext canEvaluatePolicy:currentBiometryPolicy error:&error];
    
    if (!canEvaluatePolicy) {
        [self handleBiometryError:error];
    }
    
    return canEvaluatePolicy;
}

#pragma mark Number pad delegate methods

- (void)didPressButtonWithNumber:(NSUInteger)number {
    [self.dotsControl recolorDotsTo: ++self.passcodeCounter];
    
    [self.passcodeString appendFormat:@"%lu", number];
    
    if (self.passcodeCounter == self.persistentStoragePasscodeString.length) {
        BOOL isPasscodeValid = [self validatePasscode:self.passcodeString];

        [self handlePasscodeAuthentication:isPasscodeValid];
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

#pragma mark Passcode processing

- (BOOL)validatePasscode:(NSString *)passcodeToValidate {
    return [passcodeToValidate isEqualToString:self.persistentStoragePasscodeString];
}

- (void)handlePasscodeAuthentication:(BOOL)isPasscodeValid {
    if (isPasscodeValid) {
        [self.biometryContext invalidate];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    else {
        [self.dotsControl recolorDotsTo:0];
        
        [self.passcodeString setString:@""];
        self.passcodeCounter = 0;
    }
}

#pragma mark Biometry proccessing

- (void)instantiateBiometry {
    BOOL canEvaluatePolicy = [self checkPolicyAvailability];
    
    if (!canEvaluatePolicy) { return; }
    
    NSString *localizedReason = [NSString biometryLocalizedReasonForBiometryType:self.biometryContext.biometryType];
        
    [self.biometryContext evaluatePolicy:currentBiometryPolicy
                         localizedReason:localizedReason
                                   reply:^(BOOL success, NSError * _Nullable error)
    {
        [self handleBiometryAuthenticationWithSuccess:success error:error];
    }
     ];
    
}

- (void)handleBiometryAuthenticationWithSuccess:(BOOL)success error:(NSError * _Nullable)error {
    if (success) {
        dispatch_queue_t mainQueue = dispatch_get_main_queue();

        dispatch_async(mainQueue, ^{
            [self.biometryContext invalidate];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }
    
    else {
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
            
            break;
        case LAErrorBiometryNotEnrolled:
            [self handleBiometryNotEnrolledError];
            
            break;
        default:
            NSLog(@"ERROR: %@", error);
            
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

@end
