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
#import "RINumberPadConfiguration.h"

@interface RINumberPad : UIView

@property (weak, nonatomic) id<RINumberPadDelegate> delegate;

@property (strong, nonatomic) RINumberPadConfiguration *numberPadConfiguration;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIStackView *numberPadStackView;
@property (weak, nonatomic) IBOutlet UIStackView *biometryButtonStackView;

@property (strong, nonatomic) void (^biometryFallbackActionBlock)(void);

- (IBAction)numberPadButtonTapped:(RINumberPadButton *)sender;
- (IBAction)biometryFallbackButtonTapped:(UIButton *)sender;

@property (assign, nonatomic, getter=isBiometryButtonEnabled) BOOL biometryButtonEnabled;
@property (assign, nonatomic, getter=isBiometryButtonHidden) BOOL biometryButtonHidden;

- (instancetype)initWithNumberPadConfiguration:(RINumberPadConfiguration *)numberPadConfiguration;

@end
