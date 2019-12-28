//
//  RINumberPadDelegate.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/26/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RINumberPadDelegate <NSObject>

@optional
- (void)didPressButtonWithNumber:(NSUInteger)number;
- (void)didPressClearButton;
- (void)didPressBiometryButton;

@end
