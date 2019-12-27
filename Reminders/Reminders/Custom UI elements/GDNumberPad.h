//
//  GDNumberPad.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/24/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDNumberPadButton.h"
#import "GDNumberPadDelegate.h"

@interface GDNumberPad : UIView

@property id<GDNumberPadDelegate> delegate;

@property (nonatomic) UIImage *clearIcon;
@property (nonatomic) UIImage *biometryIcon;

@property (nonatomic) UIColor *clearIconTintColor;
@property (nonatomic) UIColor *biometryIconTintColor;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIStackView *numberPadStackView;

- (IBAction)numberPadButtonPressed:(GDNumberPadButton *)sender;

- (instancetype)initWithClearIcon:(UIImage *)clearIcon biometryIcon:(UIImage *)biometryIcon;

@end