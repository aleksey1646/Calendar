//
//  AppDelegate.m
//  emptyProject
//
//  Created by A.O. on 03.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "AppDelegate.h"
#include <dlfcn.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>



@implementation GURLCache

- (NSCachedURLResponse*)cachedResponseForRequest:(NSURLRequest*)request
{
//    NSLog(@"url %@", request.URL.absoluteString);
    return [super cachedResponseForRequest:request];
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request{
    return [super storeCachedResponse:cachedResponse forRequest:request];
}

-(void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forDataTask:(NSURLSessionDataTask *)dataTask{
    return [super storeCachedResponse:cachedResponse forDataTask:dataTask ];
}

@end



@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"emptyProject" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"emptyProject.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//exiting code
@synthesize locationProvider,gCache;

-(void)notify:(NSString*) from{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = [NSString stringWithFormat:@"Alert from %@ ,%@",from,[NSDate date]];
    [localNotification setSoundName:UILocalNotificationDefaultSoundName];
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    
    /*
    NSMutableURLRequest *req=[NSMutableURLRequest requestWithURL: [NSURL URLWithString:@"http://grope.io/notify.php"] ];
    [req setHTTPBody:[ from dataUsingEncoding:NSUTF8StringEncoding  ]];
    [req setHTTPMethod:@"POST"];
    [req setValue:@"unk/known" forHTTPHeaderField:@"Content-type"];
    NSError* err=nil;
    NSURLResponse* resp=nil;
    [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:&err];
 */
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    //DO SOMETHING
    NSLog(@"background app");
//    [self notify:@"performFetchWithCompletionHandler"];
    completionHandler(UIBackgroundFetchResultNewData);

}

/*
struct CTResult
{
    int flag;
    int a;
};

id _CTServerConnectionCreate(CFAllocatorRef, void*, int*);


CFStringRef CTSIMSupportCopyMobileSubscriberCountryCode(CFAllocatorRef);
CFStringRef CTSIMSupportCopyMobileSubscriberNetworkCode(CFAllocatorRef);


#ifdef __LP64__
void _CTServerConnectionGetLocationAreaCode(id, int*);
void _CTServerConnectionGetCellID(id, int*);
#else
void _CTServerConnectionGetLocationAreaCode(struct CTResult*, id, int*);
#define _CTServerConnectionGetLocationAreaCode(connection, LAC) { struct CTResult res; _CTServerConnectionGetLocationAreaCode(&res, connection, LAC); }
void _CTServerConnectionGetCellID(struct CTResult*, id, int*);
#define _CTServerConnectionGetCellID(connection, CID) { struct CTResult res; _CTServerConnectionGetCellID(&res, connection, CID); }
#endif



id CTConnection = nil;

-(NSString*)operatorToString{
    int CID, LAC,MCC,MNC;
    
    if(CTConnection==nil){CTConnection=_CTServerConnectionCreate(NULL, NULL, NULL);}
    if(CTConnection==nil){return @"";}
    _CTServerConnectionGetCellID(CTConnection, &CID);
    _CTServerConnectionGetLocationAreaCode(CTConnection, &LAC);
    MCC = [(__bridge NSString*)CTSIMSupportCopyMobileSubscriberCountryCode(NULL) intValue];
    MNC = [(__bridge NSString*)CTSIMSupportCopyMobileSubscriberNetworkCode(NULL) intValue];
    return [NSString stringWithFormat:@"cid=%d lac=%d MCC=%d MNC=%d\n",CID,LAC,MCC,MNC];
}

 */


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
   
    // Override point for customization after application launch.
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0){
        [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    }
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    [self setLocationProvider: [[GLocationProvider alloc]init] ];
    
//    NSArray* p=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* ps=[p objectAtIndex:0];
    
    [self setGCache:[[GURLCache alloc]initWithMemoryCapacity:0 diskCapacity:0 diskPath: nil]];
    [NSURLCache setSharedURLCache:self.gCache];
    
    return YES;
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
}

@end
