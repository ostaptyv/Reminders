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

@interface LockScreenViewController ()
//MOCK:
@property BOOL isTouchId;

@property CGFloat constraintValueForTouchIdModels;
@property CGFloat constraintValueForFaceIdModels;

@property NSUInteger numberOfDots;
@property CGFloat dotBorderWidth;
@property CGFloat dotConstraintValue;

@end

@implementation LockScreenViewController

#pragma mark -viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefaultPropertyValues];
    [self setupConstraintWhichCorrectsNumberPadPosition];
    
    [self instantiateDotsStackView];
        
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

#pragma mark Setup default values

- (void)setupDefaultPropertyValues {
    self.isTouchId = YES; // change here to NO to see how it'll work for iPhones with Face ID module
        
    self.constraintValueForTouchIdModels = 94;
    self.constraintValueForFaceIdModels = 121;
    
    self.numberOfDots = 6;
    self.dotBorderWidth = 1.25;
    self.dotConstraintValue = 13;
}

#pragma mark Setup UI

- (void)setupConstraintWhichCorrectsNumberPadPosition {
    self.constraintWhichCorrectsNumberPadPosition.constant = self.isTouchId ? self.constraintValueForTouchIdModels : self.constraintValueForFaceIdModels;
    
    [self.view layoutIfNeeded];
}

- (void)instantiateDotsStackView {
    for (int i = 0; i < self.numberOfDots; i++) {
        GDDot *dot = [[GDDot alloc] initWithState:NO dotBorderWidth:self.dotBorderWidth dotColor:[UIColor blackColor]];
        
        [dot.widthAnchor constraintEqualToConstant:self.dotConstraintValue].active = YES;
        [dot.heightAnchor constraintEqualToConstant:self.dotConstraintValue].active = YES;
        
        [self.dotsStackView addArrangedSubview:dot];
    }
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
    NSLog(@"NUMBER: %lu", number);
}

- (void)didPressClearButton {
    NSLog(@"CLEAR");
}

- (void)didPressBiometryButton {
    NSLog(@"BIOMETRY");
}

@end
