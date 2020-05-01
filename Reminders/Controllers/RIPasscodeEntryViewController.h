//
//  RIPasscodeEntryViewController.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/29/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RIPasscodeEntryView.h"
#import "RIResponse.h"
#import "RIPasscodeEntryDelegate.h"
#import "RIPasscodeEntryOption.h"

@interface RIPasscodeEntryViewController : UIViewController

@property (weak, nonatomic) IBOutlet RIPasscodeEntryView *passcodeEntryView;

@property (weak, nonatomic) id<RIPasscodeEntryDelegate> delegate;

- (void)cleanStrategyInput;
- (void)revertStrategyState;

+ (RIPasscodeEntryViewController *)instanceWithEntryOption:(RIPasscodeEntryOption)entryOption;

@end
