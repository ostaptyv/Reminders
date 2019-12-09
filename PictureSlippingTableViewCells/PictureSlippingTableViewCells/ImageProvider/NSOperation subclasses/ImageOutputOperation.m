//
//  ImageOutputOperation.m
//  PictureSlippingTableViewCells
//
//  Created by Ostap Tyvonovych on 12/2/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageOutputOperation.h"
#import "ImageOutputProtocol.h"

@interface ImageOutputOperation ()

@property void (^outputBlock)(UIImage *);

@property (readwrite, nullable, atomic) UIImage *inputImage;
@property (readwrite, nullable, weak) UITableViewCell *cell;

@end

@implementation ImageOutputOperation

#pragma mark -main

- (void)main {
    if (self.isCancelled) { return; }
    
    for (int i = 0; i < self.dependencies.count; i++) {
        if (self.isCancelled) { return; }
        
        if (![self.dependencies[i] conformsToProtocol:@protocol(ImageOutputProtocol)]) { continue; }
        
        NSOperation<ImageOutputProtocol> *castedOperation = self.dependencies[i];
        self.outputBlock(castedOperation.outputImage);
        
        break;
    }
    
    if (self.isCancelled) { return; }
}

#pragma mark Initializer method

- (instancetype _Nonnull)initWithOutput:(void (^ _Nonnull)(UIImage * _Nullable))outputBlock {
    if (self = [super init]) {
        self.outputBlock = outputBlock;
    }
    
    return self;
}

@end
