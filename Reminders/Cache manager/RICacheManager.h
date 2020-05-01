//
//  RICacheManager.h
//  Reminders
//
//  Created by Ostap on 01.03.2020.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface RICacheManager : NSObject

@property (strong, nonatomic, class, readonly) RICacheManager *sharedInstance;

- (UIImage *)imageByURL:(NSURL *)url;

+ (instancetype)alloc __attribute__((unavailable("RICacheManager is a singleton object; use 'sharedInstance' property to get the object instead")));
- (instancetype)init __attribute__((unavailable("RICacheManager is a singleton object; use 'sharedInstance' property to get the object instead")));

+ (instancetype)new __attribute__((unavailable("RICacheManager is a singleton object; use 'sharedInstance' property to get the object instead")));

@end

NS_ASSUME_NONNULL_END
