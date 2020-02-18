//
//  RIPasscodeManager.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 2/14/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RIPasscodeManager.h"
#import "RIPasscodeManager+UnitTests.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>

@interface RIPasscodeManager ()

@property (strong, nonatomic, readonly) NSDictionary *attributesDictionary;

@property (strong, nonatomic) NSString *serviceName;

@end

@implementation RIPasscodeManager

@synthesize attributesDictionary = _attributesDictionary;

#pragma mark Property getters

- (NSDictionary *)attributesDictionary {
    if (_attributesDictionary == nil) {
        _attributesDictionary = @{
            (id)kSecClass: (id)kSecClassGenericPassword
        };
    }
    
    return _attributesDictionary;
}

#pragma mark Shared instance

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static RIPasscodeManager *sharedInstance;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [RIPasscodeManager new];
        
        sharedInstance.serviceName = NSBundle.mainBundle.bundleIdentifier;
    });
    
    return sharedInstance;
}

#pragma mark Set passcode method

- (BOOL)setPasscode:(NSString *)passcode forIdentifier:(NSString *)identifier withErrorCode:(NSInteger * __nullable)errorCode {
    NSInteger checkExistanceErrorCode;
    BOOL isPasscodeSet = [self checkPasscodeSetForIdentifier:identifier  withErrorCode:&checkExistanceErrorCode];
    
    if (isPasscodeSet) {
        if (errorCode != nil) {
            *errorCode = checkExistanceErrorCode == errSecSuccess ? errRemindersPasscodeAlreadySet : checkExistanceErrorCode;
        }
        return NO;
    }
    
    NSMutableDictionary *queryDictionary = [NSMutableDictionary dictionaryWithDictionary:self.attributesDictionary];
    NSData *dataFromPasscode = [passcode dataUsingEncoding:NSUTF8StringEncoding];
    
    [queryDictionary setObject:dataFromPasscode forKey:(id)kSecValueData];
    [queryDictionary setObject:[self hashServiceName:self.serviceName] forKey:(id)kSecAttrService];
    [queryDictionary setObject:identifier forKey:(id)kSecAttrAccount];
    
    OSStatus creationErrorCode = SecItemAdd((CFDictionaryRef)queryDictionary, nil);
    
    if (errorCode != nil) {
        *errorCode = (NSInteger)creationErrorCode;
    }
    
    return creationErrorCode == errSecSuccess;
}

#pragma mark Reset existing passcode method

- (BOOL)resetExistingPasscode:(NSString *)existingPasscode forIdentifier:(NSString *)identifier withErrorCode:(NSInteger * __nullable)errorCode {
    NSInteger validationErrorCode;
    BOOL isPasscodeValid = [self validatePasscode:existingPasscode forIdentifier:identifier withErrorCode:&validationErrorCode];
    
    if (!isPasscodeValid) {
        if (errorCode != nil) {
            *errorCode = validationErrorCode;
        }
        return NO;
    }
    
    return [self deletePasscode:existingPasscode forIdentifier:identifier withErrorCode:errorCode];
}

#pragma mark Delete passcode method (public for unit tests only)

- (BOOL)deletePasscode:(NSString *)passcode forIdentifier:(NSString *)identifier withErrorCode:(NSInteger * __nullable)errorCode {
    NSMutableDictionary *queryDictionary = [NSMutableDictionary dictionaryWithDictionary:self.attributesDictionary];
    NSData *dataFromPasscode = [passcode dataUsingEncoding:NSUTF8StringEncoding];
    
    [queryDictionary setObject:dataFromPasscode forKey:(id)kSecValueData];
    [queryDictionary setObject:[self hashServiceName:self.serviceName] forKey:(id)kSecAttrService];
    [queryDictionary setObject:identifier forKey:(id)kSecAttrAccount];
    
    OSStatus deletingErrorCode = SecItemDelete((CFDictionaryRef)queryDictionary);
    
    if (errorCode != nil) {
        *errorCode = (NSInteger)deletingErrorCode;
    }
    
    return deletingErrorCode == errSecSuccess;
}

#pragma mark Passcode validation method

- (BOOL)validatePasscode:(NSString *)passcodeToValidate forIdentifier:(NSString *)identifier withErrorCode:(NSInteger * __nullable)errorCode {
    NSMutableDictionary *queryDictionary = [NSMutableDictionary dictionaryWithDictionary:self.attributesDictionary];
    
    [queryDictionary setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    [queryDictionary setObject:[self hashServiceName:self.serviceName] forKey:(id)kSecAttrService];
    [queryDictionary setObject:identifier forKey:(id)kSecAttrAccount];
    [queryDictionary setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    
    CFTypeRef actualPasscode;
    OSStatus responseCode = SecItemCopyMatching((CFDictionaryRef)[queryDictionary copy], &actualPasscode);
    
    if (responseCode != errSecSuccess) {
        *errorCode = (NSInteger)responseCode;
        return NO;
    }
    
    NSData *actualPasscodeData = (__bridge NSData *)actualPasscode;
    NSString *actualPasscodeString = [[NSString alloc] initWithData:actualPasscodeData encoding:NSUTF8StringEncoding];
    
    BOOL isPasscodesEqual = [passcodeToValidate isEqualToString:actualPasscodeString];
    *errorCode = isPasscodesEqual ? errSecSuccess : errRemindersPasscodeNotValid;
    
    return isPasscodesEqual;
}

#pragma mark Change passcode method

- (BOOL)changePasscode:(NSString *)oldPasscode toNewPasscode:(NSString *)newPasscode forIdentifier:(NSString *)identifier withErrorCode:(NSInteger * __nullable)errorCode {
    NSInteger validationErrorCode;
    BOOL isPasscodeValid = [self validatePasscode:oldPasscode forIdentifier:identifier withErrorCode:&validationErrorCode];
    
    if (!isPasscodeValid) {
        if (errorCode != nil) {
            *errorCode = validationErrorCode;
        }
        return NO;
    }
    
    if ([oldPasscode isEqualToString:newPasscode]) {
        if (errorCode != nil) {
            *errorCode = errRemindersChangeToSameValue;
        }
        return NO;
    }
    
    NSData *dataFromNewPasscode = [newPasscode dataUsingEncoding:NSUTF8StringEncoding];
    NSData *dataFromOldPasscode = [oldPasscode dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *updateDictionary = @{ (id)kSecValueData: dataFromNewPasscode };
    NSMutableDictionary *queryDictionary = [NSMutableDictionary dictionaryWithDictionary:self.attributesDictionary];
    
    [queryDictionary setObject:dataFromOldPasscode forKey:(id)kSecValueData];
    [queryDictionary setObject:[self hashServiceName:self.serviceName] forKey:(id)kSecAttrService];
    
    [queryDictionary setObject:identifier forKey:(id)kSecAttrAccount];
    
    OSStatus updateErrorCode = SecItemUpdate((CFDictionaryRef)queryDictionary, (CFDictionaryRef)updateDictionary);
    
    if (errorCode != nil) {
        *errorCode = (NSInteger)updateErrorCode;
    }
    
    return updateErrorCode == errSecSuccess;
}

#pragma mark Check passcode for existance method (private)

- (BOOL)checkPasscodeSetForIdentifier:(NSString *)identifier withErrorCode:(NSInteger * __nullable)errorCode {
    NSMutableDictionary *queryDictionary = [NSMutableDictionary dictionaryWithDictionary:self.attributesDictionary];
    
    [queryDictionary setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    [queryDictionary setObject:[self hashServiceName:self.serviceName] forKey:(id)kSecAttrService];
    [queryDictionary setObject:identifier forKey:(id)kSecAttrAccount];
    
    OSStatus responseCode = SecItemCopyMatching((CFDictionaryRef)[queryDictionary copy], nil);
    
    if (errorCode != nil) {
        *errorCode = (NSInteger)responseCode;
    }

    return responseCode == errSecSuccess;
}

#pragma mark Private methods for internal purposes

- (NSData *)hashServiceName:(NSString *)serviceName {
    NSData *dataServiceName = [serviceName dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *dataServiceNameSHA256Encoded = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(dataServiceName.bytes, (CC_LONG)dataServiceName.length, dataServiceNameSHA256Encoded.mutableBytes);

    return (NSData *)[dataServiceNameSHA256Encoded copy];
}

#pragma mark Methods for unit tests

+ (RIPasscodeManager *)newInstanceForServiceName:(NSString *)serviceName {
    RIPasscodeManager *result = [RIPasscodeManager new];
    result.serviceName = serviceName;
    
    return result;
}

@end
