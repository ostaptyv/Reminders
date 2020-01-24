//
//  RIUIColor+HexInit.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/26/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import "RIUIColor+HexInit.h"

@implementation UIColor (HexInit)

- (instancetype)initWithHex:(NSString *)hex alpha:(CGFloat)alpha {
    CGFloat r, g, b;
    
    NSString *newHex = [hex hasPrefix:@"#"] ? [hex substringFromIndex:1] : hex; //remove first character if given string contains '#'
    
    if ([newHex length] != 6) { return nil; }
    
    NSScanner *scanner = [NSScanner scannerWithString:newHex];
    unsigned int hexNumber = 0;
    
    if (![scanner scanHexInt:&hexNumber]) { return nil; }
    
    r = ((hexNumber & 0xff0000) >> 16) / 255.0;
    g = ((hexNumber & 0x00ff00) >> 8) / 255.0;
    b = (hexNumber & 0x0000ff) / 255.0;

    return [self initWithRed:r green:g blue:b alpha:alpha];
}

- (instancetype)initWithHex:(NSString *)hex {
    return [self initWithHex:hex alpha:1];
}

@end
