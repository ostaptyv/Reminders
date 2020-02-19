//
//  RIPasscodeStrategyProtocol.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/29/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RIPasscodeEntryView.h"
#import "RIResponse.h"

@protocol RIPasscodeStrategyProtocol <NSObject, UIKeyInput>

@property (assign, nonatomic) BOOL editingDisabled;

- (void)cleanInput;
- (void)revertState;

- (void)execute;

- (instancetype)initWithPasscodeEntryView:(RIPasscodeEntryView *)passcodeEntryView responseBlock:(void (^)(RIResponse *))responseBlock;

@end
