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

@property (weak, nonatomic) id<RINumberPadDelegate> delegate;

@property (strong, nonatomic) UIImage *clearIcon;
@property (strong, nonatomic) UIImage *biometryIcon;

@property (strong, nonatomic) UIColor *clearIconTintColor;
@property (strong, nonatomic) UIColor *biometryIconTintColor;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIStackView *numberPadStackView;
@property (weak, nonatomic) IBOutlet UIStackView *biometryButtonStackView;

@property (strong, nonatomic) void (^biometryFallbackActionBlock)(void);

- (IBAction)numberPadButtonTapped:(RINumberPadButton *)sender;
- (IBAction)biometryFallbackButtonTapped:(UIButton *)sender;

- (void)hideBiometryButton;
- (void)showBiometryButton;

- (void)enableBiometryButton;
- (void)disableBiometryButton;

- (instancetype)initWithClearIcon:(UIImage *)clearIcon biometryIcon:(UIImage *)biometryIcon;

@end
