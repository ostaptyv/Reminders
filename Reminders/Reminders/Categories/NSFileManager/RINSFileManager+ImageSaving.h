//
//  RINSFileManager+ImageSaving.h
//  Reminders
//
//  Created by Ostap on 01.03.2020.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (ImageSaving)

@property (strong, nonatomic, nullable, readonly) NSURL *documentsURL;

- (void)createGlobalImageStoreDirectory;
- (NSURL *)createLocalImageStoreDirectory;
- (nullable NSURL *)createImageFileForURL:(NSURL *)url contents:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
