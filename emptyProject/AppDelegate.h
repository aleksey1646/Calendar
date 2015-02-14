//
//  AppDelegate.h
//  emptyProject
//
//  Created by A.O. on 03.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLocationProvider.h"
#import <CoreData/CoreData.h>
@interface GURLCache : NSURLCache

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory; 



//exiting code
-(void)notify:(NSString*) from;

@property (strong, nonatomic) UIWindow *window;
@property GLocationProvider* locationProvider;
@property GURLCache * gCache;

@end

