//
//  RIPasscodeManager+UnitTests.h
//  RemindersTests
//
//  Created by Ostap Tyvonovych on 2/17/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RIPasscodeManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface RIPasscodeManager (UnitTests)

+ (RIPasscodeManager *)newInstanceForServiceName:(NSString *)serviceName;

- (BOOL)deletePasscode:(NSString *)passcode forIdentifier:(NSString *)identifier withErrorCode:(NSInteger * __nullable)errorCode;

@end

NS_ASSUME_NONNULL_END
