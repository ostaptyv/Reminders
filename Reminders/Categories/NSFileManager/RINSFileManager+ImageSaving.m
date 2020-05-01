//
//  RINSFileManager+ImageSaving.m
//  Reminders
//
//  Created by Ostap on 01.03.2020.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RINSFileManager+ImageSaving.h"
#import "RIConstants.h"

@interface NSFileManager ()

@property (strong, nonatomic, nullable, readonly) NSURL *imageAttachmentsURL;

@end

@implementation NSFileManager (ImageSaving)

#pragma mark Property getters

- (NSURL *)documentsURL {
    NSError *error;
    NSURL *documentsURL = [self URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    
    if (error != nil) {
        NSLog(@"DESTINATION URL ERROR: %@", error);
        return nil;
    }
    
    return documentsURL;
}

- (NSURL *)imageAttachmentsURL {
    return [self.documentsURL URLByAppendingPathComponent:kImageAttachmentsFileSystemPath];;
}

#pragma mark Method realizations

- (void)createGlobalImageStoreDirectory {
    NSError *error;
    
    BOOL isSuccess = [self createDirectoryAtURL:self.imageAttachmentsURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (!isSuccess) {
        NSLog(@"GLOBAL IMAGE STORE ERROR: %@", error);
    }
}

- (NSURL *)createLocalImageStoreDirectory {
    NSError *error;
    
    NSURL *destinationUrl = [self.imageAttachmentsURL URLByAppendingPathComponent:NSUUID.UUID.UUIDString];
    
    BOOL isSuccess = [self createDirectoryAtURL:destinationUrl withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (!isSuccess) {
        NSLog(@"LOCAL IMAGE STORE ERROR: %@", error);
        return nil;
    }
    
    return destinationUrl;
}

- (NSURL *)createImageFileForURL:(NSURL *)url contents:(NSData *)data {
    NSString *path = [NSString stringWithFormat:@"%@.%@", NSUUID.UUID.UUIDString, @"png"];
    NSURL *destinationUrl = [url URLByAppendingPathComponent:path];
    
    BOOL isSuccess = [self createFileAtPath:destinationUrl.path contents:data attributes:nil];

    if (!isSuccess) {
        NSLog(@"CREATE IMAGE FILE ERROR: -createFileAtPath:contents: returned NO");
        return nil;
    }
    
    return destinationUrl;
}

@end
