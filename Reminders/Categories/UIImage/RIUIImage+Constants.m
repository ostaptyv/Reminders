//
//  RIUIImage+Constants.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/7/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RIUIImage+Constants.h"

@implementation UIImage (Constants)

+ (UIImage *)touchIdIcon {
    return [UIImage imageNamed:@"touchIdIcon"];
}
+ (UIImage *)faceIdIcon {
    return [UIImage imageNamed: @"faceIdIcon"];
}
+ (UIImage *)settingsIcon {
    return [UIImage imageNamed:@"settingsIcon"];
}
+ (UIImage *)clearIcon {
    return [UIImage systemImageNamed:@"delete.left.fill"];
}
+ (UIImage *)listIcon {
    UIImageSymbolConfiguration *listSymbolConfig = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightBold];
    return [UIImage systemImageNamed:@"list.dash" withConfiguration:listSymbolConfig];
}
+ (UIImage *)removeIcon {
    return [UIImage imageNamed:@"removeIcon"];
}

@end
