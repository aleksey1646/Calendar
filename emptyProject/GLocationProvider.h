//
//  GLocationProvider.h
//  emptyProject
//
//  Created by A.O. on 05.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class GLocationProvider;

@interface GLocationProviderPrivateDelegate : NSObject<CLLocationManagerDelegate>
@property GLocationProvider* locationProvider;
@end

@interface GLocationProvider : NSObject
@property CLLocation* lastCoordinates;
@property CLLocationManager* locationManager;
@property GLocationProviderPrivateDelegate* glcPrivateDelegate;
@property NSMutableArray * monitoringRegions;
@end
