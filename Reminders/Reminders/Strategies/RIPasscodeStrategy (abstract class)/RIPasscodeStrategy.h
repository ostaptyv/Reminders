//
//  RISetNewPasscodeStrategy.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/31/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIPasscodeStrategyProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface RIPasscodeStrategy : NSObject <RIPasscodeStrategyProtocol>

@property (assign, nonatomic) BOOL editingDisabled;

@property (assign, nonatomic, readonly) BOOL hasText;
- (void)insertText:(NSString *)text;
- (void)deleteBackward;

- (void)cleanInput;
- (void)revertState;

- (void)execute;

- (instancetype)initWithPasscodeEntryView:(RIPasscodeEntryView *)passcodeEntryView responseBlock:(void (^)(RIResponse *))responseBlock;

@end

NS_ASSUME_NONNULL_END
