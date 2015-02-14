//
//  DataManager.h
//  emptyProject
//
//  Created by Katushka Mazalova on 14.02.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataManager : NSObject

+ (DataManager*) sharedManager;

- (NSManagedObjectContext *)managedObjectContext;

@end

