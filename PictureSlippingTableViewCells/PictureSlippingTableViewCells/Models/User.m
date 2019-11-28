//
//  User.m
//  PictureSlippingTableViewCells
//
//  Created by Ostap Tyvonovych on 11/28/19.
//  Copyright © 2019 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"

@implementation User

- (id)initWithName:(NSString *)name image:(UIImage *)image{
    if (self = [super init]) {
        self.name = name;
        self.image = image;
    }
    
    return self;
}

+ (id)userWithName:(NSString *)name image:(UIImage *)image {
    return [[User alloc] initWithName:name image:image];
}

@end
