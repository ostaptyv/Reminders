//
//  RINumberPadButton.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/23/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RINumberPadButtonTag) {
    RINumberPadButtonTagZero = 0,
    RINumberPadButtonTagOne = 1,
    RINumberPadButtonTagTwo = 2,
    RINumberPadButtonTagThree = 3,
    RINumberPadButtonTagFour = 4,
    RINumberPadButtonTagFive = 5,
    RINumberPadButtonTagSix = 6,
    RINumberPadButtonTagSeven = 7,
    RINumberPadButtonTagEight = 8,
    RINumberPadButtonTagNine = 9,
    RINumberPadButtonTagClear = 10,
    RINumberPadButtonTagBiometry = 11
};

@interface RINumberPadButton : UIButton

#if TARGET_INTERFACE_BUILDER
@property IBInspectable NSUInteger buttonTag;
#else
@property RINumberPadButtonTag buttonTag;
#endif

@end

