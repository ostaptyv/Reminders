//
//  RemindersTests.m
//  RemindersTests
//
//  Created by Ostap Tyvonovych on 2/17/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Security/SecBase.h>
#import "RIPasscodeManager+UnitTests.h"

@interface RIPasscodeManagerTests : XCTestCase

@property (strong, nonatomic) RIPasscodeManager *passcodeManager;

@property (strong, nonatomic, readonly) NSString *testServiceName;
@property (strong, nonatomic, readonly) NSString *testPasscode;
@property (strong, nonatomic, readonly) NSString *testIdentifier;

@end

@implementation RIPasscodeManagerTests

#pragma mark - Property getters

- (NSString *)testServiceName {
    return [NSString stringWithFormat:@"%@.test", NSBundle.mainBundle.bundleIdentifier];
}
- (NSString *)testPasscode {
    return @"205780";
}
- (NSString *)testIdentifier {
    return @"someReallyRandomIdentifierPurposedForTests";
}

#pragma mark - Setuping and cleaning methods

- (void)setUp {
    [super setUp];
    
    self.passcodeManager = [RIPasscodeManager newInstanceForServiceName:self.testServiceName];
}

- (void)tearDown {
    [self.passcodeManager deletePasscode:self.testPasscode forIdentifier:self.testIdentifier withErrorCode:nil];

    [super tearDown];
}

#pragma mark - Test cases



#pragma mark - Set passcode method:

- (void)testSetPasscodeNewPasscode {
    NSInteger errorCode;
    
    BOOL isSetSuccessful = [self.passcodeManager setPasscode:self.testPasscode forIdentifier:self.testIdentifier withErrorCode:&errorCode];
    
    XCTAssertTrue(isSetSuccessful, @"-setPasscode:withErrorCode: returned 'NO', which indicates failure of the operation");
    XCTAssertEqual(errorCode, errSecSuccess, @"-setPasscode:withErrorCode: returned error not equal to 'errSecSuccess' with error code %i which indicates operation wasn't successfu; returned error with code: %li", errSecSuccess, errorCode);
}

- (void)testSetPasscodeAlreadySetPasscode {
    NSInteger firstSetErrorCode, secondSetErrorCode;
    
    BOOL isFirstSetSuccessful = [self.passcodeManager setPasscode:self.testPasscode forIdentifier:self.testIdentifier withErrorCode:&firstSetErrorCode];
    BOOL isSecondSetSuccessful = [self.passcodeManager setPasscode:self.testPasscode forIdentifier:self.testIdentifier withErrorCode:&secondSetErrorCode];
    
    XCTAssertTrue(isFirstSetSuccessful, @"first call of -setPasscode:withErrorCode: returned 'NO', which indicates passcode set operation failure");
    XCTAssertFalse(isSecondSetSuccessful, @"second call of -setPasscode:withErrorCode: returned 'YES', which indicates that previous call hasn't set passcode as it had to be done");
    XCTAssertEqual(firstSetErrorCode, errSecSuccess, @"first call of -setPasscode:withErrorCode: returned error not equal to 'errSecSuccess' with error code %i which indicates operation wasn't successfu; returned error with code: %li", errSecSuccess, firstSetErrorCode);
    XCTAssertEqual(secondSetErrorCode, errRemindersPasscodeAlreadySet, @"second call of -setPasscode:withErrorCode: returned error not equal to 'errRemindersPasscodeAlreadySet' with error code %li which indicates that passcode already set and can't be set again by calling this function (there's another way to do this); returned error with code: %li", errRemindersPasscodeAlreadySet, secondSetErrorCode);
}

#pragma mark - Reset existing passcode method:

- (void)testResetPasscodeResetExisting {
    NSInteger setErrorCode, resetErrorCode;
    BOOL isSetSuccessful = [self.passcodeManager setPasscode:self.testPasscode forIdentifier:self.testIdentifier withErrorCode:&setErrorCode];
    
    BOOL isResetSuccessful = [self.passcodeManager resetExistingPasscode:self.testPasscode forIdentifier:self.testIdentifier withErrorCode:&resetErrorCode];
    
    XCTAssertTrue(isSetSuccessful, @"-setPasscode:withErrorCode: returned 'NO', which indicates failure of the operation");
    XCTAssertTrue(isResetSuccessful, @"-resetExistingPasscode:withErrorCode: returned 'NO', which indicates failure of the operation");
    XCTAssertEqual(setErrorCode, errSecSuccess, @"-setPasscode:withErrorCode: returned error not equal to 'errSecSuccess' with error code %i which indicates operation wasn't successfu; returned error with code: %li", errSecSuccess, setErrorCode);
    XCTAssertEqual(resetErrorCode, errSecSuccess, @"-resetExistingPasscode:withErrorCode: returned error not equal to 'errSecSuccess' with error code %i which indicates operation wasn't successfu; returned error with code: %li", errSecSuccess, resetErrorCode);
}

- (void)testResetPasscodeResetNonExisting {
    NSInteger errorCode;
    
    BOOL isResetSuccessful = [self.passcodeManager resetExistingPasscode:@"967532" forIdentifier:self.testIdentifier withErrorCode:&errorCode];
    
    XCTAssertFalse(isResetSuccessful, @"-resetExistingPasscode:withErrorCode: returned 'YES', which indicates undefined behavior: we haven't set any passcode to be able to reset one; consider error code coming along with call of this function");
    XCTAssertEqual(errorCode, errSecItemNotFound, @"-resetExistingPasscode:withErrorCode: returned error not equal to 'errSecItemNotFound' with error code %i, which may mean that there is some passcode in Keychain which matched with given \"wrong\" passcode; returned error with code: %li", errSecItemNotFound, errorCode);
}

#pragma mark - Change passcode method:

- (void)testChangePasscodeValidChange {
    NSInteger setErrorCode, changeErrorCode;
    BOOL isSetSuccessful = [self.passcodeManager setPasscode:self.testPasscode forIdentifier:self.testIdentifier withErrorCode:&setErrorCode];
    
    BOOL isChangeSuccessful = [self.passcodeManager changePasscode:self.testPasscode toNewPasscode:@"123456" forIdentifier:self.testIdentifier withErrorCode:&changeErrorCode];
    
    XCTAssertTrue(isSetSuccessful, @"-setPasscode:withErrorCode: returned 'NO', which indicates failure of the operation");
    XCTAssertTrue(isChangeSuccessful, @"-changePasscode:toNewPasscode:withErrorCode: returned 'NO', which indicates failure of the operation");
    XCTAssertEqual(setErrorCode, errSecSuccess, @"-setPasscode:withErrorCode: returned error not equal to 'errSecSuccess' with error code %i which indicates operation wasn't successfu; returned error with code: %li", errSecSuccess, setErrorCode);
    XCTAssertEqual(changeErrorCode, errSecSuccess, @"-changePasscode:toNewPasscode:withErrorCode: returned error not equal to 'errSecSuccess' with error code %i which indicates operation wasn't successfu; returned error with code: %li", errSecSuccess, changeErrorCode);
}

- (void)testChangePasscodeChangeToSameValue {
    NSInteger setErrorCode, changeErrorCode;
    BOOL isSetSuccessful = [self.passcodeManager setPasscode:self.testPasscode forIdentifier:self.testIdentifier withErrorCode:&setErrorCode];
    
    BOOL isChangeSuccessful = [self.passcodeManager changePasscode:self.testPasscode toNewPasscode:self.testPasscode forIdentifier:self.testIdentifier withErrorCode:&changeErrorCode];
    
    XCTAssertTrue(isSetSuccessful, @"-setPasscode:withErrorCode: returned 'NO', which indicates failure of the operation");
    XCTAssertFalse(isChangeSuccessful, @"-changePasscode:toNewPasscode:withErrorCode: returned 'YES', which indicates undefined behavior: it supposed to throw the 'errRemindersChangeToSameValue' error and return 'NO' to warn of changing to the same passcode event; consider error code coming along with this function call");
    XCTAssertEqual(setErrorCode, errSecSuccess, @"-setPasscode:withErrorCode: returned error not equal to 'errSecSuccess' with error code %i which indicates operation wasn't successfu; returned error with code: %li", errSecSuccess, setErrorCode);
    XCTAssertEqual(changeErrorCode, errRemindersChangeToSameValue, @"-changePasscode:toNewPasscode:withErrorCode: returned error not equal to 'errRemindersChangeToSameValue' with error code %li which indicates method hasn't restricted user from changing to the same passcode event; returned error with code: %li", errRemindersChangeToSameValue, changeErrorCode);
}

- (void)testChangePasscodeWhenPasscodeNotSet {
    NSInteger errorCode;
    
    BOOL isChangeSuccessful = [self.passcodeManager changePasscode:self.testPasscode toNewPasscode:@"123456" forIdentifier:self.testIdentifier withErrorCode:&errorCode];
    
    XCTAssertFalse(isChangeSuccessful, @"-changePasscode:toNewPasscode:withErrorCode: returned 'YES', which indicates undefined behavior: it can't change any passcode since we haven't set one; consider error code coming along with this function call");
    XCTAssertEqual(errorCode, errSecItemNotFound, @"-changePasscode:toNewPasscode:withErrorCode: returned error not equal to 'errSecItemNotFound' with error code %i which indicates undefined behavior: it can't change any passcode since we haven't set one; returned error with code: %li", errSecItemNotFound, errorCode);
}

#pragma mark - Validate passcode method:

- (void)testValidatePasscodeValidPasscode {
    NSInteger setErrorCode, validationErrorCode;
    BOOL isSetSuccessful = [self.passcodeManager setPasscode:self.testPasscode forIdentifier:self.testIdentifier withErrorCode:&setErrorCode];
    
    BOOL isPasscodeValid = [self.passcodeManager validatePasscode:self.testPasscode forIdentifier:self.testIdentifier withErrorCode:&validationErrorCode];
    
    XCTAssertTrue(isSetSuccessful, @"-setPasscode:withErrorCode: returned 'NO', which indicates failure of the operation");
    XCTAssertTrue(isPasscodeValid, @"-validatePasscode:withErrorCode: returned 'NO', which indicates failure of the operation");
    XCTAssertEqual(setErrorCode, errSecSuccess, @"-setPasscode:withErrorCode: returned error not equal to 'errSecSuccess' with error code %i which indicates operation wasn't successfu; returned error with code: %li", errSecSuccess, setErrorCode);
    XCTAssertEqual(validationErrorCode, errSecSuccess, @"-validatePasscode:withErrorCode: returned error not equal to 'errSecSuccess' with error code %i which indicates operation wasn't successful; returned error with code: %li", errSecSuccess, validationErrorCode);
}

- (void)testValidatePasscodeWrongPasscode {
    NSInteger setErrorCode, validationErrorCode;
    NSString *wrongPasscode = @"123456";
    BOOL isSetSuccessful = [self.passcodeManager setPasscode:self.testPasscode forIdentifier:self.testIdentifier withErrorCode:&setErrorCode];

    BOOL isValidationSuccessful = [self.passcodeManager validatePasscode:wrongPasscode forIdentifier:self.testIdentifier withErrorCode:&validationErrorCode];
    
    XCTAssertTrue(isSetSuccessful, @"-setPasscode:withErrorCode: returned 'NO', which indicates failure of the operation");
    XCTAssertFalse(isValidationSuccessful, @"-validatePasscode:withErrorCode: returned 'YES', which indicates undefined behavior: we have set test passcode (@\"%@\"), then passed to the function's call unvalid passcode (@\"%@\"), and they appeared to be equal (%@ == %@); consider error code coming along with this function call", self.testPasscode, wrongPasscode, self.testPasscode, wrongPasscode);
    XCTAssertEqual(setErrorCode, errSecSuccess, @"-setPasscode:withErrorCode: returned error not equal to 'errSecSuccess' with error code %i which indicates operation wasn't successful; returned error with code: %li", errSecSuccess, setErrorCode);
    XCTAssertEqual(validationErrorCode, errRemindersPasscodeNotValid, @"-validatePasscode:withErrorCode: returned error not equal to 'errRemindersPasscodeNotValid' with error code %li which indicates wrong behavior: we're validating wrong passcode; returned error with code: %li", errRemindersPasscodeNotValid, validationErrorCode);
}

@end
