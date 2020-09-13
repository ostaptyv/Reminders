//
//  RINumberPadConfiguration.m
//  Reminders
//
//  Created by Ostap on 13.09.2020.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RINumberPadConfiguration.h"
#import "RIUIImage+Constants.h"
#import "RIUIColor+Constants.h"

@implementation RINumberPadConfiguration

#pragma mark - Initializers

- (instancetype)initWithClearIcon:(UIImage *)clearIcon biometryIcon:(UIImage *)biometryIcon clearIconTintColor:(UIColor *)clearIconTintColor biometryIconTintColor:(UIColor *)biometryIconTintColor {
    self = [super init];
    
    if (self) {
        self.clearIcon = clearIcon;
        self.biometryIcon = biometryIcon;
        self.clearIconTintColor = clearIconTintColor;
        self.biometryIconTintColor = biometryIconTintColor;
    }
    
    return self;
}

@end
