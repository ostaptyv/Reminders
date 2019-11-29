//
//  User.h
//  PictureSlippingTableViewCells
//
//  Created by Ostap Tyvonovych on 11/28/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property NSString *name;
@property UIImage *image;

- (instancetype)initWithName:(NSString *)name image:(UIImage *)image;

@end
