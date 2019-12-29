//
//  RINumberPad.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/24/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RINumberPadButton.h"
#import "RINumberPadDelegate.h"

@interface RINumberPad : UIView

@property id<RINumberPadDelegate> delegate;

@property (nonatomic) UIImage *clearIcon;
@property (nonatomic) UIImage *biometryIcon;

@property (nonatomic) UIColor *clearIconTintColor;
@property (nonatomic) UIColor *biometryIconTintColor;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIStackView *numberPadStackView;

- (IBAction)numberPadButtonPressed:(RINumberPadButton *)sender;

- (void)hideBiometryButton;

- (instancetype)initWithClearIcon:(UIImage *)clearIcon biometryIcon:(UIImage *)biometryIcon;

@end
