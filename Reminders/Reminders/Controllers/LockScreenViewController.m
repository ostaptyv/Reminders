//
//  LockScreenViewController.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/19/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LockScreenViewController.h"
#import "UIImage+ImageWithImageScaledToSize.h"
#import "UIColor+HexInit.h"
#import "GDDot.h"

@interface LockScreenViewController ()
//MOCK:
@property BOOL isTouchId;

@property CGFloat constraintValueForTouchIdModels;
@property CGFloat constraintValueForFaceIdModels;

@property NSMutableString *passcodeString;
@property (nonatomic) NSUInteger passcodeCounter;

//MOCK:
@property NSString *persistentStoragePasscodeString;

@end

@implementation LockScreenViewController

#pragma mark -viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefaultPropertyValues];
    [self setupConstraintWhichCorrectsNumberPadPosition];
            
    [self setupNumberPad];
}

#pragma mark +instance

+ (LockScreenViewController *)instance {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LockScreenViewController" bundle:nil];
    return [storyboard instantiateInitialViewController];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark Property setters

- (void)setPasscodeCounter:(NSUInteger)passcodeCounter {
    if (passcodeCounter < 0 || passcodeCounter > self.dotsControl.dotsCount) { return; }
    
    _passcodeCounter = passcodeCounter;
}

#pragma mark Setup default values

- (void)setupDefaultPropertyValues {
//    MOCK:
    self.isTouchId = NO; // change here to NO to see how it'll work for iPhones with Face ID module
        
    self.constraintValueForTouchIdModels = 50;
    self.constraintValueForFaceIdModels = 42;
    
    self.passcodeString = [NSMutableString new];
    self.passcodeCounter = 0;
    
//    MOCK:
    self.persistentStoragePasscodeString = @"123456"; // change here to change the passcode
}

#pragma mark Setup UI

- (void)setupConstraintWhichCorrectsNumberPadPosition {
    self.constraintWhichCorrectsNumberPadPosition.constant = self.isTouchId ? self.constraintValueForTouchIdModels : self.constraintValueForFaceIdModels;
    
    [self.view layoutIfNeeded];
}

- (void)setupNumberPad {
    UIImage *clearIcon = [UIImage systemImageNamed:@"delete.left.fill"];
    UIImage *touchIdIcon = [UIImage imageNamed:@"touchIdIcon"];
    UIImage *faceIdIcon = [UIImage imageNamed:@"faceIdIcon"];
    
    NSString *touchIdHexColor = @"FF2D55";
    NSString *faceIdHexColor = @"0091FF";
    
    UIImage *biometryIcon = self.isTouchId ? touchIdIcon : faceIdIcon;
    
    self.numberPad.clearIcon = clearIcon;
    self.numberPad.biometryIcon = biometryIcon;
    
    self.numberPad.clearIconTintColor = [UIColor grayColor];
    self.numberPad.biometryIconTintColor = [[UIColor alloc] initWithHex:self.isTouchId ? touchIdHexColor : faceIdHexColor];
        
    self.numberPad.delegate = self;
}

#pragma mark Delegate methods

- (void)didPressButtonWithNumber:(NSUInteger)number {
    [self.dotsControl recolorDotsTo: ++self.passcodeCounter];
    
    [self.passcodeString appendFormat:@"%lu", number];
    
    if (self.passcodeCounter == self.persistentStoragePasscodeString.length) {
        BOOL isPasscodeValid = [self validatePasscode:self.passcodeString];

        if (isPasscodeValid) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.dotsControl recolorDotsTo:0];
            
            [self.passcodeString setString:@""];
            self.passcodeCounter = 0;
        }
    }
}

- (void)didPressClearButton {
    [self.dotsControl recolorDotsTo: --self.passcodeCounter];
    
    if (self.passcodeString.length == 0) { return; }
    
    [self.passcodeString deleteCharactersInRange:NSMakeRange(self.passcodeString.length - 1, 1)];
}

- (void)didPressBiometryButton {
    NSLog(@"BIOMETRY");
}

- (BOOL)validatePasscode:(NSString *)passcodeToValidate {
    return [passcodeToValidate isEqualToString:self.persistentStoragePasscodeString];
}

@end
