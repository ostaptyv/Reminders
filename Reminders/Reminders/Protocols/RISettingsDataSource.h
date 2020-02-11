//
//  RISettingsDataSource.h
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/28/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

@protocol RISettingsDataSource <NSObject>

@property (assign, nonatomic, readonly) BOOL isPasscodeSet;

@end
