//
//  RISetNewPasscodeStrategy.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/31/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIPasscodeStrategyProtocol.h"

@interface RIPasscodeStrategy : NSObject <RIPasscodeStrategyProtocol>

@property (assign, nonatomic) BOOL editingDisabled;

@property (assign, nonatomic, readonly) BOOL hasText;
- (void)insertText:(nonnull NSString *)text;
- (void)deleteBackward;

- (void)execute;

- (nonnull instancetype)initWithPasscodeEntryView:(nonnull RIPasscodeEntryView *)passcodeEntryView responseBlock:(void (^ __nonnull)(RIResponse * __nonnull))responseBlock;

@end
