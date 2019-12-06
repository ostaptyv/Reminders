//
//  ImageOutputOperation.h
//  PictureSlippingTableViewCells
//
//  Created by Ostap Tyvonovych on 12/2/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageOutputOperation : NSOperation

@property (readonly, strong, nullable) UIImage *inputImage;

- (instancetype _Nonnull)initWithOutput:(void (^ _Nonnull)(UIImage * _Nullable))outputBlock;

@end
