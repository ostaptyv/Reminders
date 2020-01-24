//
//  RIDotsControl.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 12/27/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RIDot.h"

IB_DESIGNABLE @interface RIDotsControl : UIView

@property (assign, atomic) IBInspectable NSUInteger dotsCount;
@property (assign, atomic) IBInspectable CGFloat dotsSpacing;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak,   nonatomic) IBOutlet UIStackView *dotsStackView;

@property (assign, atomic) UINotificationFeedbackType notificationFeedbackType;

- (void)recolorDotsTo:(NSInteger)dotPosition;

- (void)shakeControlWithHaptic:(BOOL)shouldUseHaptic;

- (instancetype)initWithDotsCount:(NSUInteger)dotsCount;

@end
