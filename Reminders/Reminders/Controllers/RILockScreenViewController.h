//
//  RILockScreenViewController.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/19/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RIDot.h"
#import "RINumberPad.h"
#import "RINumberPadButton.h"
#import "RIDotsControl.h"
#import "RINumberPadDelegate.h"

@interface RILockScreenViewController : UIViewController <RINumberPadDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet RIDotsControl *dotsControl;
@property (weak, nonatomic) IBOutlet RINumberPad *numberPad;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWhichCorrectsNumberPadPosition;
+ (RILockScreenViewController *)instance;

- (void)didPressButtonWithNumber:(NSUInteger)number;
- (void)didPressClearButton;
- (void)didPressBiometryButton;

@end
