//
//  RIAppDelegate.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 11/20/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RICoreDataStack.h"

@interface RIAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic, readonly) RICoreDataStack *coreDataStack;

@end

