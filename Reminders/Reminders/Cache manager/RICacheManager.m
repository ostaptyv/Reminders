//
//  RICacheManager.m
//  Reminders
//
//  Created by Ostap on 01.03.2020.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RICacheManager.h"

@interface RICacheManager ()

@property (strong, nonatomic) NSCache *cache;

@end

@implementation RICacheManager

+ (instancetype)sharedInstance {
    static RICacheManager *sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [RICacheManager new];
    });
    
    return sharedInstance;
}

- (UIImage *)imageByURL:(NSURL *)url {
    UIImage *imageFromCache = [self.cache objectForKey:url.path];
    
    if (imageFromCache == nil) {
        NSError *error;
        NSData *imageData = [NSData dataWithContentsOfURL:url options:0 error:&error];
        if (imageData == nil) {
            NSLog(@"ERRRRORO: %@", error);
        }
        UIImage *image = [UIImage imageWithData:imageData];
        
        [self.cache setObject:image forKey:url.path];
        
        return image;
    } else {
        return imageFromCache;
    }
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.cache = [NSCache new];
    }
    
    return self;
}

@end
