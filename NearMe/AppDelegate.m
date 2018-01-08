//
//  AppDelegate.m
//  NearMe
//
//  Created by Talentelgia on 6/17/15.
//  Copyright (c) 2015 Talentelgia. All rights reserved.
//

#import "AppDelegate.h"
#import "Constant.h"
@import Firebase;

// Google api key
static NSString *const kAPIKey = @"AIzaSyDDAsw9_Ym9ihss-L7Y4PElVrhMN5Xoqfo";

@interface AppDelegate ()<UIAlertViewDelegate> {
    Reachability* internetReachable;
    Reachability* hostReachable;
    
    BOOL isInternetWorking;
    
    UIAlertView *internet_Alert;
    

}
@end

@implementation AppDelegate
@synthesize currentPoints, _lat, _long;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc ]initWithFrame: [UIScreen mainScreen].bounds];
     [FIRApp configure];
    
    // Root View
    CategoryViewController *categoryView = [[CategoryViewController alloc]initWithNibName:@"CategoryViewController" bundle:[NSBundle mainBundle]];
    
    // For static lat ,longitude
    _lat = 30.730101;
    
    _long = 76.838941;
    
    currentPoints = CLLocationCoordinate2DMake(_lat, _long);
    
    //Get User current location.
    [LocationManagerSingleton sharedSingleton];
    
    
    //Set Key for
    if ([kAPIKey length] == 0) {
        
        // Blow up if APIKey has not yet been set.
        NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
        NSString *format = @"Configure APIKey inside Appdelegate.h for your " @"bundle `%@`, static NSString const kAPIKey = Your KAPIKey ";
        @throw [NSException exceptionWithName:@"AppDelegate" reason:[NSString stringWithFormat:format, bundleId] userInfo:nil];
        
    }else {
        [GMSServices provideAPIKey:kAPIKey];         // Set google GMSServices key.
    }
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    //Reachability Class for Check InternetConnection
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    NSLog(@"%@",internetReachable);
    
    hostReachable = [Reachability reachabilityWithHostName:@"www.google.com"];
    [hostReachable startNotifier];
    NSLog(@"%@",hostReachable);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    
    // Navigtion Controller
    UINavigationController*  navigationController = [[UINavigationController alloc]initWithRootViewController:categoryView];
    
    self.window.rootViewController = navigationController;  //Set navigation on root class
    
    [self.window makeKeyAndVisible];
    
    return YES;
    
}

- (void)checkNetworkStatus:(NSNotification *)status
{
    //CheckNetworkStatus Through Reachability Class
    NetworkStatus internetStatus=[internetReachable currentReachabilityStatus];
    
    switch (internetStatus)
    {
        case NotReachable:
        {
            isInternetWorking=FALSE;
            NSLog(@"INTERNET NOT REACHABLE");
        }
            break;
            
        case ReachableViaWiFi:
        case ReachableViaWWAN:
        {
            NSLog(@"INTERNET WORKING");
            isInternetWorking=TRUE;
        }
        default:
            break;
    }
    
    NetworkStatus hostStatus=[hostReachable currentReachabilityStatus];
    
    switch (hostStatus)
    {
        case NotReachable:
            NSLog(@"HOST NOT REACHABLE");
            break;
            
        case ReachableViaWiFi:
        case ReachableViaWWAN:
            NSLog(@"HOST WORKING");
            
        default:
            break;
    }
    
    [self presentErrorView];
    
}

- (void)presentErrorView
{
    
    if (!isInternetWorking) {
        
        internet_Alert = [UIAlertView new];
        
        NSString *error_msg = @"This application requires internet connectivity to function correctly. Please check your Internet connection and try again.";
        
        internet_Alert.title = @"Error";
        internet_Alert.message = error_msg;
        internet_Alert.delegate = self;
        [internet_Alert addButtonWithTitle:@"OK"];
        [internet_Alert show];
        
    }else {
        [internet_Alert dismissWithClickedButtonIndex:0 animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        [self presentErrorView];
        
    }
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.talentelgia.NearMe" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        
        return _managedObjectModel;
        
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NearMe" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
    
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        
        return _persistentStoreCoordinator;
        
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NearMe.sqlite"];
    
    NSError *error = nil;
    
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        
        dict[NSUnderlyingErrorKey] = error;
        
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
        abort();
        
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        
        return _managedObjectContext;
        
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (!coordinator) {
        
        return nil;
        
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    return _managedObjectContext;
    
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext != nil) {
        
        NSError *error = nil;
        
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            
            abort();
            
        }
        
    }
    
}
@end
