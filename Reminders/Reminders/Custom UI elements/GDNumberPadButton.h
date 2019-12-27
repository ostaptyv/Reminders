//
//  GDNumberPadButton.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/23/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GDNumberPadButtonTag) {
    GDNumberPadButtonTagZero = 0,
    GDNumberPadButtonTagOne = 1,
    GDNumberPadButtonTagTwo = 2,
    GDNumberPadButtonTagThree = 3,
    GDNumberPadButtonTagFour = 4,
    GDNumberPadButtonTagFive = 5,
    GDNumberPadButtonTagSix = 6,
    GDNumberPadButtonTagSeven = 7,
    GDNumberPadButtonTagEight = 8,
    GDNumberPadButtonTagNine = 9,
    GDNumberPadButtonTagClear = 10,
    GDNumberPadButtonTagBiometry = 11
};

@interface GDNumberPadButton : UIButton

#if TARGET_INTERFACE_BUILDER
@property IBInspectable NSUInteger buttonTag;
#else
@property GDNumberPadButtonTag buttonTag;
#endif

@end
