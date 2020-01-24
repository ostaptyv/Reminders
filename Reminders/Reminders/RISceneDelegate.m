#import "RISceneDelegate.h"
#import "RITasksListViewController.h"
#import "RICreateReminderViewController.h"
#import "RIConstants.h"

@interface RISceneDelegate ()

@property (strong, atomic) RIReminder *reminder;

@property (strong, atomic) RITasksListViewController *tasksListVc;

@property (strong, atomic) UINavigationController *navigationControllerWithCreateReminderVc;

@property (strong, atomic) RICreateReminderViewController *existingCreateReminderVc;
@property (strong, atomic) RICreateReminderViewController *freshCreateReminderVc;

@property (assign, atomic) BOOL shouldRaiseNewCreateReminderVc;

@end

@implementation RISceneDelegate

#pragma mark Handle URL Scheme request

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    UIOpenURLContext *urlContext = URLContexts.allObjects.firstObject;

    if (URLContexts.count > 1) {
        NSLog(@"WARNING: More than 1 UIOpenURLContext passed to URLContexts set; %s:%d", __FILE_NAME__, __LINE__);
    }
    
    self.reminder = [self parseURL:urlContext.URL];
    
    [self manageViewControllersShowingBehavior];
}

#pragma mark Manage UIViewControllers' showing behavior

- (void)manageViewControllersShowingBehavior {
    self.tasksListVc = [self makeTasksListViewController];
    
    self.navigationControllerWithCreateReminderVc = [RICreateReminderViewController instanceWithCompletionHandler:nil];
    
    self.existingCreateReminderVc = [self retrieveExistingCreateReminderVcUsing:self.tasksListVc];
    self.freshCreateReminderVc = [self makeFreshCreateReminderVcUsing:self.navigationControllerWithCreateReminderVc];
    
    if (self.existingCreateReminderVc != nil) {
        [self.existingCreateReminderVc cancelReminderCreationShowingAlert:YES];
        
        self.shouldRaiseNewCreateReminderVc = YES;
    }
    else {
        [self.tasksListVc presentViewController:self.navigationControllerWithCreateReminderVc animated:YES completion: ^{
            [self setupCreateReminderVc:self.freshCreateReminderVc withReminder:self.reminder];
        }];
        
        self.shouldRaiseNewCreateReminderVc = NO;
    }
}

#pragma mark Parse URL

- (RIReminder *)parseURL:(NSURL *)url {
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

#pragma mark Factory methods

- (RITasksListViewController *)makeTasksListViewController {
    UINavigationController *tasksListVc;
    
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes.allObjects) {
        if (![scene isKindOfClass:UIWindowScene.class]) { continue; }
        
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        
        tasksListVc = (UINavigationController *)windowScene.windows.firstObject.rootViewController;
        
        break;
    }
    
    return (RITasksListViewController *)tasksListVc.viewControllers.firstObject;
}

- (RICreateReminderViewController *)retrieveExistingCreateReminderVcUsing:(UIViewController *)parentVc {
    UINavigationController *navigationController = (UINavigationController *)parentVc.presentedViewController;
    
    RICreateReminderViewController *existingCreateReminderVc = (RICreateReminderViewController *)navigationController.viewControllers.firstObject;
    
    existingCreateReminderVc.showsAlertOnCancel = YES;
    existingCreateReminderVc.delegate = self;
    
    return existingCreateReminderVc;
}

- (RICreateReminderViewController *)makeFreshCreateReminderVcUsing:(UINavigationController *)navigationController {
    RICreateReminderViewController *freshCreateReminderVc = (RICreateReminderViewController *)navigationController.viewControllers.firstObject;
    
    freshCreateReminderVc.showsAlertOnCancel = YES;
    freshCreateReminderVc.delegate = self;
    
    return freshCreateReminderVc;
}

#pragma mark Create reminder delegate methods

- (void)didCreateReminderWithResponse:(RIResponse *)response viewController:(UIViewController *)viewController {
    if (self.freshCreateReminderVc == viewController && self.tasksListVc.createReminderCompletionHandler != nil) {
        self.tasksListVc.createReminderCompletionHandler(response);
    }
    
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didPressAlertProceedButtonOnParent:(UIViewController *)parentViewController {
    if (self.shouldRaiseNewCreateReminderVc) {
        if (self.existingCreateReminderVc == parentViewController) {
            [parentViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
        [self.tasksListVc presentViewController:self.navigationControllerWithCreateReminderVc animated:YES completion:^{
            [self setupCreateReminderVc:self.freshCreateReminderVc withReminder:self.reminder];
        }];
        
        self.shouldRaiseNewCreateReminderVc = NO;
    }
    
    else {
        [parentViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didPressAlertCancelButton {
    self.shouldRaiseNewCreateReminderVc = NO;
}

#pragma mark Customizing create reminder VC with data retrieved from URL

- (void)setupCreateReminderVc:(RICreateReminderViewController *)createReminderVc withReminder:(RIReminder *)reminder {
    createReminderVc.textView.text = reminder.text;
    createReminderVc.arrayOfImages = reminder.arrayOfImages;
    
    [createReminderVc.collectionView reloadData];
}

@end
