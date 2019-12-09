//
//  ImageLoadOperation.m
//  PictureSlippingTableViewCells
//
//  Created by Ostap Tyvonovych on 12/2/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageLoadOperation.h"

@interface ImageLoadOperation ()

@property (nullable, atomic, readwrite) UIImage *outputImage;

@end

@implementation ImageLoadOperation

#pragma mark -main

- (void)main {
    if (self.isCancelled) { return; }

    NSData *data = [NSData dataWithContentsOfURL:self.imageUrl];
    
    if (self.isCancelled) { return; }
    
    self.outputImage = [UIImage imageWithData:data];
    
    if (self.isCancelled) { self.outputImage = nil; return; }
}

#pragma mark Lazy -setImageUrl:

- (void)setImageUrl:(NSURL *)imageUrl {
    if (!self.imageUrl) {
        _imageUrl  = imageUrl;
    }
}

#pragma mark Initializer method

- (instancetype)initWithImageUrl:(NSURL *)imageUrl {
    if (self = [super init]) {
        self.imageUrl = imageUrl;
    }
    
    return self;
}

@end
