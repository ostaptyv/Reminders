//
//  ImageProvider.h
//  PictureSlippingTableViewCells
//
//  Created by Ostap Tyvonovych on 12/5/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageProvider : NSObject

@property NSURL *imageUrl;

- (void)cancel;

- (instancetype)initWithImageUrl:(NSURL *)imageUrl completion:(void (^)(UIImage *))completionBlock;

@end
