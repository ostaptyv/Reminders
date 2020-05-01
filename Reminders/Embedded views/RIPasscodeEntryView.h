//
//  RIPasscodeEntryView.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/30/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RIDotsControl.h"

@interface RIPasscodeEntryView : UIView <UIKeyInput>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet RIDotsControl *dotsControl;
@property (weak, nonatomic) IBOutlet UILabel *notMatchingPasscodesLabel;
@property (weak, nonatomic) IBOutlet UILabel *failedAttemptsLabel;

@property (weak, nonatomic) id<UIKeyInput> delegate;

@property (assign, nonatomic) NSUInteger failedAttemptsCount;

@property (assign, nonatomic, readonly) BOOL hasText;

- (void)insertText:(NSString *)text;
- (void)deleteBackward;

@end
