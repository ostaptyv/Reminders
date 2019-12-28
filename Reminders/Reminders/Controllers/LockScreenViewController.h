//
//  LockScreenViewController.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/19/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDDot.h"
#import "GDNumberPad.h"
#import "GDNumberPadButton.h"
#import "GDDotsControl.h"
#import "GDNumberPadDelegate.h"

@interface LockScreenViewController : UIViewController <GDNumberPadDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet GDDotsControl *dotsControl;
@property (weak, nonatomic) IBOutlet GDNumberPad *numberPad;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWhichCorrectsNumberPadPosition;
+ (LockScreenViewController *)instance;

- (void)didPressButtonWithNumber:(NSUInteger)number;
- (void)didPressClearButton;
- (void)didPressBiometryButton;

@end
