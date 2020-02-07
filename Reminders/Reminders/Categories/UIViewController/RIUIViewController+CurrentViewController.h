//
//  RIUIViewController+CurrentViewController.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/6/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CurrentViewController)

@property (strong, atomic, readonly) UIViewController *currentViewController;

@end
