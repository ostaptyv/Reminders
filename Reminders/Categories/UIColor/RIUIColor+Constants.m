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
    return [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return UIColor.whiteColor;
        } else {
            return UIColor.blackColor;
        }
    }];
}

+ (UIColor *)touchIdIconColor {
    return [[UIColor alloc] initWithHex:@"FF2D55"];
}
+ (UIColor *)faceIdIconColor {
    return [[UIColor alloc] initWithHex:@"0091FF"];
}

+ (UIColor *)numberPadButtonColor {
    return [[UIColor alloc] initWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return [UIColor numberPadButtonColorDarkTheme];
        } else {
            return [UIColor numberPadButtonColorLightTheme];
        }
    }];
}
+ (UIColor *)passcodeEntryMainBackgroundColor {
    return [[UIColor alloc] initWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return [UIColor numberPadMainBackgroundColorDarkTheme];
        } else {
            return [UIColor numberPadMainBackgroundColorLightTheme];
        }
    }];
}

+ (UIColor *)numberPadButtonColorLightTheme {
    return [[UIColor alloc] initWithHex:@"E3E5E6"];
}
+ (UIColor *)numberPadButtonColorDarkTheme {
    return [[UIColor alloc] initWithHex:@"333333"];
}
+ (UIColor *)numberPadMainBackgroundColorLightTheme {
    return [[UIColor alloc] initWithHex:@"EFEFF5"];
}
+ (UIColor *)numberPadMainBackgroundColorDarkTheme {
    return UIColor.blackColor;
}

@end
