//
//  ImageProvider.m
//  PictureSlippingTableViewCells
//
//  Created by Ostap Tyvonovych on 12/5/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ImageProvider.h"
#import "ImageLoadOperation.h"
#import "ImageOutputOperation.h"

@interface ImageProvider ()

@property NSOperationQueue *operationQueue;

@end

@implementation ImageProvider

- (instancetype)initWithImageUrl:(NSURL *)imageUrl completion:(void (^)(UIImage *))completionBlock {
    if (self = [super init]) {
        self.imageUrl = imageUrl;
    }
    
    self.operationQueue = [NSOperationQueue new];
    self.operationQueue.maxConcurrentOperationCount = 2;
    
    ImageLoadOperation *imageLoadOperation = [[ImageLoadOperation alloc] initWithImageUrl:imageUrl];
    ImageOutputOperation *imageOutputOperation = [[ImageOutputOperation alloc] initWithOutput:completionBlock];
    
    [imageOutputOperation addDependency:imageLoadOperation];
    
    [self.operationQueue addOperations:@[imageLoadOperation, imageOutputOperation] waitUntilFinished:NO];
    
    return self;
}

- (void)cancel {
    [self.operationQueue cancelAllOperations];
}

@end
