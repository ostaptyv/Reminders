#import "SceneDelegate.h"
#import "RITasksListViewController.h"
#import "RICreateReminderViewController.h"
#import "RIConstants.h"

@interface SceneDelegate ()

@property RIReminder *reminder;

@property RITasksListViewController *tasksListVc;

@property UINavigationController *navigationControllerWithCreateReminderVc;

@property RICreateReminderViewController *existingCreateReminderVc;
@property RICreateReminderViewController *newwCreateReminderVc;

@property BOOL shouldRaiseNewCreateReminderVc;

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    
}


- (void)sceneDidDisconnect:(UIScene *)scene {
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
}


- (void)sceneWillResignActive:(UIScene *)scene {
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
}

#pragma mark Handle URL Scheme request

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    UIOpenURLContext *urlContext = URLContexts.allObjects.firstObject;

    if (URLContexts.count > 1) {
        NSLog(@"More than 1 UIOpenURLContext passed to URLContexts set; %s:%d", __FILE_NAME__, __LINE__);
    }
    
    self.reminder = [self parseURL:urlContext.URL];
    
    [self manageViewControllersShowingBehavior];
}

#pragma mark Manage UIViewControllers' showing behavior

- (void)manageViewControllersShowingBehavior {
    self.tasksListVc = [self makeTasksListViewController];
    
    self.navigationControllerWithCreateReminderVc = [RICreateReminderViewController instanceWithCompletionHandler:nil];
    
    self.existingCreateReminderVc = [self retrieveExistingCreateReminderVcUsing:self.tasksListVc];
    self.newwCreateReminderVc = [self makeNewCreateReminderVcUsing:self.navigationControllerWithCreateReminderVc];
    
    if (self.existingCreateReminderVc != nil) {
        [self.existingCreateReminderVc cancelReminderCreationShowingAlert:YES];
        
        self.shouldRaiseNewCreateReminderVc = YES;
    }
    else {
        [self.tasksListVc presentViewController:self.navigationControllerWithCreateReminderVc animated:YES completion: ^{
            [self setupCreateReminderVc:self.newwCreateReminderVc withReminder:self.reminder];
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

- (NSMutableArray<UIImage *> *)parseURLComponentsForImages:(NSURLComponents *)urlComponents {
    NSMutableDictionary<NSString *, NSString *> *argumentDict = [NSMutableDictionary new];
    
    for (NSURLQueryItem *queryItem in urlComponents.queryItems) {
        argumentDict[queryItem.name] = queryItem.value;
    }
    
    NSMutableArray<UIImage *> *result = [NSMutableArray new];
    
    NSUInteger count = [self getArrayCountFromArgumentsDictionary:argumentDict];
    
    for (NSUInteger i = 0; i < count; i++) {
        NSString *arrayName = [NSString stringWithFormat:@"%@[%lu]", imagesArrayURLArgument, i];
        
        NSString *base64EncodedImageData = argumentDict[arrayName];
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64EncodedImageData options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        UIImage *image = [UIImage imageWithData:imageData];
        
        [result addObject:image];
    }
    
    return result;
}

- (NSUInteger)getArrayCountFromArgumentsDictionary:(NSDictionary<NSString *, NSString *> *)argumentDict {
    NSUInteger result = 0;
    
    for (NSString *key in argumentDict.allKeys) {
        NSString *argumentString = [NSString stringWithFormat:@"%@[", imagesArrayURLArgument];
        
        if (![key containsString:argumentString]) { continue; }
        
        result++;
    }
    
    return result;
}

#pragma mark Factory methods

- (RITasksListViewController *)makeTasksListViewController {
    UINavigationController *tasksListVc;
    
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes.allObjects) {
        if (![scene isKindOfClass:[UIWindowScene class]]) { continue; }
        
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

- (RICreateReminderViewController *)makeNewCreateReminderVcUsing:(UINavigationController *)navigationController {
    RICreateReminderViewController *newwCreateReminderVc = (RICreateReminderViewController *)navigationController.viewControllers.firstObject;
    
    newwCreateReminderVc.showsAlertOnCancel = YES;
    newwCreateReminderVc.delegate = self;
    
    return newwCreateReminderVc;
}

#pragma mark Create reminder delegate methods

- (void)didCreateReminderWithResponse:(RIResponse *)response viewController:(UIViewController *)viewController {
    if (self.newwCreateReminderVc == viewController) {
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
            [self setupCreateReminderVc:self.newwCreateReminderVc withReminder:self.reminder];
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
