//
//  ImageOutputProtocol.h
//  PictureSlippingTableViewCells
//
//  Created by Ostap Tyvonovych on 12/2/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageOutputProtocol <NSObject>

@property (readonly, nullable, atomic) UIImage *outputImage;

@end
