//
//  ImageLoadOperation.h
//  PictureSlippingTableViewCells
//
//  Created by Ostap Tyvonovych on 12/2/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageOutputProtocol.h"

@interface ImageLoadOperation : NSOperation <ImageOutputProtocol>

@property (readonly, nonnull, nonatomic) NSURL *imageUrl;
@property (readonly, nullable, atomic) UIImage *outputImage;

- (instancetype _Nonnull)initWithImageUrl:(NSURL * _Nonnull)imageUrl;

@end
