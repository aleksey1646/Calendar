//
//  PlacesViewController.m
//  emptyProject
//
//  Created by A.O. on 05.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#define DEBUG_VARIABLES

#import "PlacesViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "GLang.h"
#import "Constants.h"
#import "GLocationProvider.h"


@interface PlacesViewController ()

@end

@implementation PlacesViewController
@synthesize webView,segmentcontrol;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [webView setDelegate:self];
    [self.view bringSubviewToFront:segmentcontrol];
    [segmentcontrol setBackgroundColor:[[UIColor alloc]initWithWhite:1 alpha:0.5]];
    [self.navigationItem setTitle: [GLang getString:@"Places.title"] ];
    [segmentcontrol setTitle:[GLang getString:@"Places.segments.here"]  forSegmentAtIndex:0];
    [segmentcontrol setTitle:[GLang getString:@"Places.segments.today"]  forSegmentAtIndex:1];
    [segmentcontrol setTitle:[GLang getString:@"Places.segments.all"]  forSegmentAtIndex:2];
    // Do any additional setup after loading the view.
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [webView loadRequest:
     [NSURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://grope.io/maps/?t=%lu",time(NULL)] ] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0]
     ];
    
}

- (NSString *)createRandomName
{
    NSTimeInterval timeStamp = [ [ NSDate date ] timeIntervalSince1970 ];
    NSString *randomName = [ NSString stringWithFormat:@"%f", timeStamp];
    randomName = [ randomName stringByReplacingOccurrencesOfString:@"." withString:@"" ];
    return randomName;
}
-(void)insertMarkerToMap:(CLLocationCoordinate2D) coord text:(NSString*) text click_id:(NSString* )click_id title:(NSString *)title {
    NSString* js=[NSString stringWithFormat:@"insertMarkerToMap(%f,%f,'%@','%@','%@');",coord.latitude,coord.longitude, text,title,click_id ];
    [webView stringByEvaluatingJavaScriptFromString: js ];
}
/*
-(void)insertMarkerToMap:(CLLocationCoordinate2D) coord text:(NSString*) text click_id:(NSString* )click_id{
    
    NSString *title = [NSString stringWithFormat:@"You here!"];
    
    NSString* js=[NSString stringWithFormat:@"insertMarkerToMap(%f,%f,'%@','%@','%@');",coord.latitude,coord.longitude, text,click_id,title];
    [webView stringByEvaluatingJavaScriptFromString: js ];
}
*/
//[self performSelectorOnMainThread:@selector(yourmethod:)withObject:obj waitUntilDone:YES]

- (void) myThreadMainMethod:(id) thread {
    //while (true){
    
   // dispatch_sync(dispatch_get_main_queue(), ^{
        
        AppDelegate* app=[[UIApplication sharedApplication] delegate];
        GLocationProvider *provider = [app locationProvider];
    
        if (provider.locationManager.monitoredRegions.count>0) {
            
           // for (int i = 0; i<provider.locationManager.monitoredRegions.count; i++) { //{
                
               
              int i = 1;
                for(CLCircularRegion* reg in [provider.locationManager monitoredRegions]){
                    
                    [self insertMarkerToMap:reg.center text:[NSString stringWithFormat:@"%d",i] click_id:[self createRandomName] title:[NSString stringWithFormat:@"REGION#%d",i]];
                    
                 //  [self insertMarkerToMap:reg.center text:[NSString stringWithFormat:@"REGION#%d",i] click_id:[self createRandomName]];
                    i++;
                }
                
                
           // }
            
        }
  
}
- (BOOL)webView:(UIWebView *)webView_p shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    NSLog(@"request = %@",request);
    AppDelegate* app=[[UIApplication sharedApplication] delegate];
    CLLocation * last_loc= [[app locationProvider]lastCoordinates];

    if([[[request URL]scheme] isEqualToString:@"internal"]){
        NSString* path=[[request URL]path];
        if([path isEqualToString:@"/init1"]){
#ifdef DEBUG_VARIABLES
            
            
            if(!last_loc){ last_loc=[[CLLocation alloc]initWithLatitude:55.75448 longitude:37.61965]; }//temporary!!! for debug!
#endif
            if(last_loc){
                NSLog(@"ll=%@\n",last_loc);
                [webView stringByEvaluatingJavaScriptFromString:
                 [NSString stringWithFormat:@"createMapWithCoordinates('%f','%f','%d');",last_loc.coordinate.longitude,last_loc.coordinate.latitude,mapRadius]
                 ];
                
            }
        }else if([path isEqualToString:@"/create_map_compelete"]){
            
            [self insertMarkerToMap:last_loc.coordinate text:@"Your here" click_id:@"coords#iam" title:@"Current location"];
            

            //[self insertMarkerToMap:last_loc.coordinate text:@"Your here" click_id:@"coords#iam"];
        }else if([path isEqualToString:@"/fully_loaded"]){
            //First Fully loaded.
            
            [self performSelectorOnMainThread:@selector(myThreadMainMethod:)withObject:nil waitUntilDone:YES];
           
            
        }else{
            [[[UIAlertView alloc]initWithTitle:@"Alert" message:[[request URL]path] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil]show];
        }
    
        return NO;
    }

    
    if(strstr([[[request URL]host] UTF8String],"grope.io")==0){
        [[UIApplication sharedApplication]openURL:[request URL]];
        return false;
    }
    return true;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
