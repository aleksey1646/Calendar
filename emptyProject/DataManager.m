//
//  DataManager.m
//  emptyProject
//
//  Created by Katushka Mazalova on 14.02.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "DataManager.h"
#import "AppDelegate.h"//????

@implementation DataManager

+ (DataManager*) sharedManager {
    
    static DataManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataManager alloc] init];
    });
    
    return manager;
}

#pragma mark - ManagedObjectContext


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
@end
