//
//  RIURLSchemeHandlerService.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/24/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RIURLSchemeHandlerService.h"
#import "RIConstants.h"

@implementation RIURLSchemeHandlerService

- (RIReminder *)parseReminderSchemeURL:(NSURL *)url {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    
    if (urlComponents == nil) {
        NSLog(@"Invalid URL; NSURLComponents failed initialization");
        return nil;
    }
    
    NSString *text = urlComponents.host;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0.0];
    NSMutableArray<UIImage *> *arrayOfImages = [self parseURLComponentsForImages:urlComponents];
    
    return [[RIReminder alloc] initWithText:text dateInstance:date arrayOfImages:arrayOfImages];
}

- (NSMutableArray<UIImage *> *)parseURLComponentsForImages:(NSURLComponents *)URLComponents {
    NSMutableArray<UIImage *> *result = [NSMutableArray new];
    NSURLQueryItem *imagesQueryItem = [self retrieveImagesQueryItemFromURLComponents:URLComponents];
    
    if (imagesQueryItem == nil) {
        NSLog(@"PARSE URL: '%@' argument not found.", kImagesArrayURLArgumentName);
    }
    
    NSData *arrayOfImagesData = [[NSData alloc] initWithBase64EncodedString:imagesQueryItem.value options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSSet *classesSet = [NSSet setWithArray:@[NSMutableArray.class, UIImage.class]];
    NSError *error;
    
    result = [NSKeyedUnarchiver unarchivedObjectOfClasses:classesSet fromData:arrayOfImagesData error:&error];
    
    if (error != nil) {
        NSLog(@"NSKEYEDUNARCHIVIER ERROR: %@", error);
    }
    
    return result;
}

- (NSURLQueryItem *)retrieveImagesQueryItemFromURLComponents:(NSURLComponents *)URLComponents {
    NSURLQueryItem *imagesQueryItem;
    
    for (NSURLQueryItem *queryItem in URLComponents.queryItems) {
        if (![queryItem.name isEqualToString:kImagesArrayURLArgumentName]) { continue; }
        
        imagesQueryItem = queryItem;
        
        break;
    }
    
    return imagesQueryItem;
}

@end
