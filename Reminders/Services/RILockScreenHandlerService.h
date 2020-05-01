//
//  RILockScreenHandlerService.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 3/11/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RILockScreenHandlerService : NSObject

- (void)handleWillEnterForeground;
- (void)handleDidEnterBackground;

- (instancetype)initWithWindow:(UIWindow *)window;

@end

NS_ASSUME_NONNULL_END
