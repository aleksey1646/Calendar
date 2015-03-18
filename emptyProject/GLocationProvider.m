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

- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    //55,75448
    //37,61965
    //CLCircularRegion *reg = (CLCircularRegion *)region;
   
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"didEnterRegion region: %@",region.description] message:[NSString stringWithFormat:@"Your coordinate in region lat: %f lon: %f",manager.location.coordinate.latitude,manager.location.coordinate.longitude] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
    //delete old regions
    if ([self.locationProvider.locationManager.monitoredRegions count] > 0) {
        for (id obj in self.locationProvider.locationManager.monitoredRegions)
            [self.locationProvider.locationManager stopMonitoringForRegion:obj];
    }
    
    for (int i = 0; i<=7; i++) {
        
        CLRegion *region = [self registerRegionsWithLocationManager:self.locationProvider.locationManager andIdentifier:[NSString stringWithFormat:@"%d",i] andLon:manager.location.coordinate.longitude andLat:manager.location.coordinate.latitude];
        [self.locationProvider.locationManager startMonitoringForRegion:region];
        
    }
    
    
    
}
- (void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"didExitRegion region: %@",region.description] message:[NSString stringWithFormat:@"Your coordinate in region lat: %f lon: %f",manager.location.coordinate.latitude,manager.location.coordinate.longitude] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];

    
}
-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    
    
//    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:[NSString stringWithFormat:@"Started monitoring for region: %@",[region description]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [alert show];
   

}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:region.identifier message:[NSString stringWithFormat:@"Failed to start monitoring for region: %@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
}


#pragma mark - Register 20 regions


-(CLRegion*) registerRegionsWithLocationManager:(CLLocationManager *)manager andIdentifier:(NSString *)identifier andLon:(CLLocationDegrees)lon andLat:(CLLocationDegrees)lat {
    
    //Косинусом и синусом мы проецируем вектор от центра окружности до точки и получаем результат в метрах. Эти метры переводим в географические градусы и прибавляем к центру
    
    //поделить надо на косинус широты
    
    //Это учитывает диаметр. диаметр по экватору куда больше чем диаметр нашего региона. А эти пропорции вычислялись как отношение окружности с этим диаметром на 360 градусов
    
    //1 geg = 30m => 20 deg = 600m
    //0.000277777778
    CLLocationDegrees latitude = lat+20*arcConvert*cos(0+45*[identifier integerValue]*M_PI/180);
    CLLocationDegrees longitude = lon+20*arcConvert/cos(lat*M_PI/180)*sin(0+45*[identifier integerValue]*M_PI/180);
    
    
    CLLocationDistance radius = 300;
    
    CLRegion *targetRegion = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake(latitude, longitude)
                                                                       radius:radius
                                                                   identifier:identifier];
    
    targetRegion.notifyOnEntry = YES;
    targetRegion.notifyOnExit = YES;
    
    
    
    // Check if support is unavailable
    if ( ![CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Failed to initialise region monitoring: support unavailable" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
       
    }
    
    // Check if authorised
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert!" message:@"Failed to initialise region monitoring: app not authorized to use location services" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
       
        
    }

    return targetRegion;

}



//whenever changing the coordinates on a distance between cells (every 5 minutes)
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if([locations count]){
        CLLocation* o=[locations objectAtIndex:0];
        [self.locationProvider setLastCoordinates: o ];
        
        
        //delete old regions
        if ([self.locationProvider.locationManager.monitoredRegions count] > 0) {
            for (id obj in self.locationProvider.locationManager.monitoredRegions)
                [self.locationProvider.locationManager stopMonitoringForRegion:obj];
        }

        for (int i = 0; i<=7; i++) {
            
             CLRegion *region = [self registerRegionsWithLocationManager:self.locationProvider.locationManager andIdentifier:[NSString stringWithFormat:@"%d",i] andLon:o.coordinate.longitude andLat:o.coordinate.latitude];
            [self.locationProvider.locationManager startMonitoringForRegion:region];
            
        }
       
        
        

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
    
    [locationManager startMonitoringSignificantLocationChanges];//2 вар-т уведомлений
    
    return self;
}

@end
