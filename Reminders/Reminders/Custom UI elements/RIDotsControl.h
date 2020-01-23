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

@property (nonatomic) IBInspectable NSUInteger dotsCount;
@property (nonatomic) IBInspectable CGFloat dotsSpacing;

@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIStackView *dotsStackView;

@property UINotificationFeedbackType notificationFeedbackType;

- (void)recolorDotsTo:(NSInteger)dotPosition;

- (void)shakeControlWithHaptic:(BOOL)shouldUseHaptic;

- (instancetype)initWithDotsCount:(NSUInteger)dotsCount;

@end
