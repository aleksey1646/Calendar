//
//  GLocationProvider.m
//  emptyProject
//
//  Created by A.O. on 05.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "GLocationProvider.h"
#import <CoreLocation/CoreLocation.h>

@class GLocationProvider;

@implementation GLocationProviderPrivateDelegate
@synthesize locationProvider;
-(instancetype)init:(GLocationProvider*)provider{
    self=[super init];
    if(!self){return nil;}
    [self setLocationProvider:provider];
    return self;
}

- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
}
- (void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if([locations count]){
        CLLocation* o=[locations objectAtIndex:0];
        [self.locationProvider setLastCoordinates: o ];
    }
}

@end


@implementation GLocationProvider : NSObject 
@synthesize locationManager,glcPrivateDelegate,lastCoordinates,monitoringRegions;

-(instancetype)init{
    self=[super init];
    if(!self){return nil;}
    [self setLocationManager: [[CLLocationManager alloc]init] ];
    [self setGlcPrivateDelegate:[[GLocationProviderPrivateDelegate alloc]init:self]];
    [locationManager setDelegate:self.glcPrivateDelegate];
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [locationManager requestAlwaysAuthorization];
    }
    [self setMonitoringRegions: [[NSMutableArray alloc]init] ];

    for(CLRegion* reg in [locationManager monitoredRegions]){
        [locationManager stopMonitoringForRegion:reg];
    }
    
    [locationManager startMonitoringSignificantLocationChanges];
    
    return self;
}

@end
