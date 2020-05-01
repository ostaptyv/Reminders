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
    RINumberPadButtonTagOne,
    RINumberPadButtonTagTwo,
    RINumberPadButtonTagThree,
    RINumberPadButtonTagFour,
    RINumberPadButtonTagFive,
    RINumberPadButtonTagSix,
    RINumberPadButtonTagSeven,
    RINumberPadButtonTagEight,
    RINumberPadButtonTagNine,
    
    RINumberPadButtonTagClear,
    RINumberPadButtonTagBiometry
};

@interface RINumberPadButton : UIButton

#if TARGET_INTERFACE_BUILDER
@property (assign, nonatomic) IBInspectable NSUInteger buttonTag;
#else
@property RINumberPadButtonTag buttonTag;
#endif

@end

