//
//  RISceneDelegate.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/20/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RICreateReminderDelegate.h"

@interface RISceneDelegate : UIResponder <UIWindowSceneDelegate, RICreateReminderDelegate>

@property (strong, nonatomic) UIWindow * window;

@end

