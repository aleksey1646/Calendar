//
//  Note.h
//  emptyProject
//
//  Created by Katushka Mazalova on 14.02.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSDate * timeInterval;
@property (nonatomic, retain) NSString * dayWeek;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) NSString * textNote;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSNumber * notificationPlace;
@property (nonatomic, retain) NSNumber * notificationTime;
@property (nonatomic, retain) NSNumber * statusPause;
@property (nonatomic, retain) NSNumber * statusComplete;

@end
