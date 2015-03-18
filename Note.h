//
//  Note.h
//  emptyProject
//
//  Created by Katushka Mazalova on 06.03.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * dayWeek;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * notificationPlace;
@property (nonatomic, retain) NSNumber * notificationTime;
@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) NSNumber * statusComplete;
@property (nonatomic, retain) NSNumber * statusPause;
@property (nonatomic, retain) NSString * textNote;
@property (nonatomic, retain) NSString * timeInterval;
@property (nonatomic, retain) NSString * title;

@end
