//
//  RIURLSchemeHandlerService.m
//  Reminders
//
//  Created by Ostap Tyvonovych on 1/24/20.
//  Copyright © 2020 Ostap Tyvonovych. All rights reserved.
//

#import "RIURLSchemeHandlerService.h"
#import "RIConstants.h"
#import "RICoreDataStack.h"
#import "RIAppDelegate.h"

@interface RIURLSchemeHandlerService ()

@property (strong, nonatomic, readonly) RICoreDataStack *coreDataStack;

@end

@implementation RIURLSchemeHandlerService

#pragma mark - Property getters

@synthesize coreDataStack = _coreDataStack;

- (RICoreDataStack *)coreDataStack {
    if (_coreDataStack == nil) {
        RIAppDelegate *appDelegate = (RIAppDelegate *)UIApplication.sharedApplication.delegate;
        _coreDataStack = appDelegate.coreDataStack;
    }
    
    return _coreDataStack;
}

#pragma mark - Public methods

- (RIReminderRaw *)parseReminderSchemeURL:(NSURL *)url {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    
    if (urlComponents == nil) {
        NSLog(@"Invalid URL; NSURLComponents failed initialization");
        return nil;
    }
        
    NSString *text = urlComponents.host;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0.0];
    NSMutableArray<UIImage *> *arrayOfImages = [self parseURLComponentsForImages:urlComponents];
    
    return [[RIReminderRaw alloc] initWithText:text dateInstance:date arrayOfImages:[arrayOfImages copy]];
}

#pragma mark - Private methods

- (NSMutableArray<UIImage *> *)parseURLComponentsForImages:(NSURLComponents *)URLComponents {
    NSMutableArray<UIImage *> *result = [NSMutableArray new];
    NSURLQueryItem *imagesQueryItem = [self retrieveImagesQueryItemFromURLComponents:URLComponents];
    
    if (imagesQueryItem == nil) {
        NSLog(@"PARSE URL: '%@' argument not found.", kImagesArrayURLArgumentName);
        return result;
    }
    
    NSData *arrayOfImagesData = [[NSData alloc] initWithBase64EncodedString:imagesQueryItem.value options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSSet *classesSet = [NSSet setWithArray:@[NSArray.class, NSMutableArray.class, UIImage.class]];
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
        if (![queryItem.name isEqualToString:kImagesArrayURLArgumentName]) {
            continue;
        }
        
        imagesQueryItem = queryItem;
        
        break;
    }
    
    return imagesQueryItem;
}

@end
