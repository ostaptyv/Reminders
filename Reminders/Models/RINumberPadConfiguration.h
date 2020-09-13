//
//  RINumberPadConfiguration.h
//  Reminders
//
//  Created by Ostap on 13.09.2020.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RINumberPadConfiguration : NSObject

@property (strong, nonatomic) UIImage *clearIcon;
@property (strong, nonatomic) UIImage *biometryIcon;
@property (strong, nonatomic) UIColor *clearIconTintColor;
@property (strong, nonatomic) UIColor *biometryIconTintColor;

// TODO: Will be implemented later
@property (strong, nonatomic) NSDictionary<NSNumber *, UIColor *> *buttonColors;

- (instancetype)initWithClearIcon:(UIImage *)clearIcon biometryIcon:(UIImage *)biometryIcon clearIconTintColor:(UIColor *)clearIconTintColor biometryIconTintColor:(UIColor *)biometryIconTintColor;

@end

NS_ASSUME_NONNULL_END
