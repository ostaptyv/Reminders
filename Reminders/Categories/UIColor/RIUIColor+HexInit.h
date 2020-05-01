//
//  RIUIColor+HexInit.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/26/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexInit)

- (instancetype)initWithHex:(NSString *)hex alpha:(CGFloat)alpha;
- (instancetype)initWithHex:(NSString *)hex;

@end
