//
//  RIUIColor+Constants.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/28/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "RIUIColor+Constants.h"
#import "RIUIColor+HexInit.h"

@implementation UIColor (Constants)

+ (UIColor *)defaultDotColor {
    return UIColor.blackColor;
}

+ (UIColor *)touchIdIconColor {
    return [[UIColor alloc] initWithHex:@"FF2D55"];
}
+ (UIColor *)faceIdIconColor {
    return [[UIColor alloc] initWithHex:@"0091FF"];
}
+ (UIColor *)numberPadButtonColor {
    return [[UIColor alloc] initWithHex:@"E3E5E6"];
}

@end
