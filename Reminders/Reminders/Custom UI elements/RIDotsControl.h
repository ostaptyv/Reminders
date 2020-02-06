//
//  RIDotsControl.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/27/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RIDot.h"
#import "RIDotConfiguration.h"

IB_DESIGNABLE @interface RIDotsControl : UIView

@property (assign, atomic) IBInspectable NSUInteger dotsCount;
@property (assign, atomic) IBInspectable CGFloat dotsSpacing;
@property (assign, atomic) IBInspectable RIDotConfiguration *dotConfiguration;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak,   nonatomic) IBOutlet UIStackView *dotsStackView;

@property (assign, atomic) UINotificationFeedbackType notificationFeedbackType;

@property (assign, atomic) NSInteger currentDotPosition;

- (void)recolorDotsTo:(NSInteger)dotPosition completionHandler:(void (^)(BOOL))completionHandler;
- (void)recolorDotsTo:(NSInteger)dotPosition;

- (void)shakeControlWithHaptic:(BOOL)shouldUseHaptic;

- (instancetype)initWithDotsCount:(NSUInteger)dotsCount;

@end
