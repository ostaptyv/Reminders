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

@property (strong, atomic) id<RINumberPadDelegate> delegate;

@property (strong, atomic) UIImage *clearIcon;
@property (strong, atomic) UIImage *biometryIcon;

@property (strong, atomic) UIColor *clearIconTintColor;
@property (strong, atomic) UIColor *biometryIconTintColor;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak,   nonatomic) IBOutlet UIStackView *numberPadStackView;
@property (weak,   nonatomic) IBOutlet UIStackView *biometryButtonStackView;

- (IBAction)numberPadButtonPressed:(RINumberPadButton *)sender;

- (void)hideBiometryButton;
- (void)showBiometryButton;

- (instancetype)initWithClearIcon:(UIImage *)clearIcon biometryIcon:(UIImage *)biometryIcon;

@end
