//
//  RINumberPadButton.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/23/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "RINumberPadButton.h"

//PRIVATE CONSTANT:
const UIControlState state = UIControlStateNormal;

@interface RINumberPadButton ()

@property NSString *previouslySavedTitleLabelString;
@property UIColor *previouslySavedImageViewTintColor;
@property UIColor *previouslySavedBackgroundColor;

@end

@implementation RINumberPadButton

- (void)setHiddenAppearance:(BOOL)hiddenAppearance {
    if (hiddenAppearance == _hiddenAppearance) { return; }
    
    if (hiddenAppearance) {
        self.previouslySavedTitleLabelString = self.titleLabel.text;
        self.previouslySavedImageViewTintColor = self.tintColor;
        self.previouslySavedBackgroundColor = self.backgroundColor;
    }
    
    NSString *newTitle = hiddenAppearance ? @"" : self.previouslySavedTitleLabelString;
    UIColor *newTintColor = hiddenAppearance ? [UIColor clearColor] : self.previouslySavedImageViewTintColor;
    UIColor *newBackgroundColor = hiddenAppearance ? [UIColor clearColor] : self.previouslySavedBackgroundColor;
    
    self.userInteractionEnabled = !hiddenAppearance;
    
    [self setTitle:newTitle forState:state];
    
    self.imageView.tintColor = newTintColor;
    self.backgroundColor = newBackgroundColor;
    
    _hiddenAppearance = hiddenAppearance;
}

@end
