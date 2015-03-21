//
//  PlaceNoteViewController.m
//  emptyProject
//
//  Created by Katushka Mazalova on 04.03.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#define DEBUG_VARIABLES

#import "PlaceNoteViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "GLang.h"
#import "URLNetworkHelper.h"
#import "AppDelegate.h"



@interface PlaceNoteViewController () <UISearchBarDelegate, UIWebViewDelegate,UIScrollViewDelegate> {
    UIView *circleView;
    UILabel *circleRadiusView;
    UIView *clearDarkView;
    int radiusCircle;
    int zoom;
    double lon;
    double lat;
    
}

@property (weak, nonatomic) IBOutlet UILabel *informLabel;
@property (weak, nonatomic) IBOutlet UISwitch *useSwitch;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIWebView *mapWebView;




@end

@implementation PlaceNoteViewController


#pragma mark - Change zoom mapWebView scrollView



- (void) changeZoomWith:(int)zoomLevel {
    
    if (circleView) {
        float radius = circleView.layer.cornerRadius;
        
        
        //  AppDelegate* app=[[UIApplication sharedApplication] delegate];
        //CLLocation * last_loc= [[app locationProvider]lastCoordinates];
        
        
        /*
         150 DPI = 150 PPI = 150 пикселей на 1 дюйм = 150 пикселей на 2,54 см = 150 пикселей на 0,0254 м
         
         Так один пиксель имеет размер 0,0254 м / 150 = 0,00016933 м.
         
         Масштабы нашей карте 1: 150000.Масштаб отношение расстояния на карте к соответствующему расстоянию на земле.
         
         Так соответствующее расстояние одного пикселя на земле является 0.00016933 м * 150000 = 25,4 м.
         
         Один пиксель занимает площадь 25,4 м * 25,4 м = 645,16 квадратных метров.
         
         0,0254 / 326 = +0,00007791411
         +0,00007791411 * +72223,822090 = +5,62725481894
         
         
         326 - айфон
         401 - если айфон 6+
         132 - айпад
         264 ppi retina айпад (mini retina 326 ppi)
         */
        int ppi = 326;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            ppi = 132;
        } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            ppi = 326;
        }
        
        
        float metresScale = 564.24861 * pow(2, 21 - zoomLevel);
        
        float OnePixelDistanceInMeters =  (inchMetres)/ppi*metresScale;
        
        int result = lroundf((float)radius/100*75*OnePixelDistanceInMeters);
        radiusCircle = result;
        
        int resultMOrKm = result>=1000?lroundf((float)result/1000):result;
        
        
        
        NSMutableString *strFormat = [NSMutableString stringWithString:[GLang getString:@"Places.search"]];
        [strFormat appendString:[NSString stringWithFormat:@"%d ",resultMOrKm]];
        
        //[NSMutableString stringWithFormat:@"In radius: %d ",resultMOrKm];
        
        if (result>=1000) {
            [strFormat appendString:@"km."];
        } else {
            [strFormat appendString:@"m."];
        }
        
        
        [circleRadiusView setTextAlignment:NSTextAlignmentCenter];
        [circleRadiusView setText:strFormat];
        NSLog(@"circleRadiusView %@",[circleRadiusView text]);
        
        
        
    }
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"didRotateFromInterfaceOrientation");
    [self addCircleView];
    [self.mapWebView bringSubviewToFront:clearDarkView];
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        [circleRadiusView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:9]];
    }
    
    
    [self changeZoomWith:zoom];
    [self clearMarkers];
    
    if (![self.searchBar.text isEqualToString:@""]) {
        if ([self.useSwitch isOn]) {
            return;
        }
        if (self.note.category) {
            
            [self setCommandAndParamsWithName:_searchBar.text andCategory:self.note.category];
            
        } else {
            
            [self setCommandAndParamsWithName:_searchBar.text andCategory:@""];
        }
    }
    
    
    
    
    
    
}

- (void) addCircleView {
    
    
    if (circleView) {
        [circleView removeFromSuperview];
    }
    if (circleRadiusView) {
        [circleRadiusView removeFromSuperview];
    }
    if (circleView.subviews) {
        for (int i = 0; i<circleView.subviews.count; i++) {
            UIView *view = [circleView.subviews objectAtIndex:i];
            [view removeFromSuperview];
        }
    }
    
    float size = self.mapWebView.frame.size.width > self.mapWebView.frame.size.height? self.mapWebView.frame.size.height: self.mapWebView.frame.size.width;
    
    
    circleView = [[UIView alloc]initWithFrame:CGRectMake(0+(self.mapWebView.frame.size.width - size +size/6)/2, 0+(self.mapWebView.frame.size.height - size +size/6)/2, size-size/6, size-size/6)];
    
    circleView.layer.cornerRadius = circleView.frame.size.width/2;
    
    circleView.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:1 alpha:0.13];
    
    
    circleView.layer.borderWidth = 0.7f;
    circleView.layer.borderColor = [UIColor colorWithRed:0 green:0.5 blue:1 alpha:0.3].CGColor;
    circleView.clipsToBounds = YES;
    //circleView.layer.contentsCenter.origin.x
    CGRect rect = CGRectMake(self.mapWebView.bounds.size.width/2-circleView.layer.cornerRadius/16, self.mapWebView.bounds.size.height/2+circleView.layer.cornerRadius/16, circleView.layer.cornerRadius/8, circleView.layer.cornerRadius/8);
    
    // CGRect rect = CGRectMake(self.mapWebView.frame.size.width/2-circleView.layer.cornerRadius/8, self.mapWebView.frame.size.height/2-circleView.layer.cornerRadius/8, circleView.layer.cornerRadius/8, circleView.layer.cornerRadius/8);
    
    
    UIView *smalCircle = [[UIView alloc]initWithFrame:rect];
    [smalCircle setCenter:CGPointMake(circleView.bounds.origin.x+circleView.layer.cornerRadius, circleView.bounds.origin.y+circleView.layer.cornerRadius)];
    
    // smalCircle.center = circleView.center;
    
    smalCircle.layer.cornerRadius = smalCircle.frame.size.width/2;
    smalCircle.backgroundColor = [UIColor colorWithRed:0 green:0.5 blue:1 alpha:0.5];
    
    
    circleRadiusView = [[UILabel alloc]initWithFrame:CGRectZero];
    float sizeLabel = (self.mapWebView.frame.size.height-circleView.frame.size.height)/3;
    
    [circleRadiusView setFrame:CGRectMake(circleView.frame.origin.x+circleView.frame.size.width/4, circleView.frame.origin.y-sizeLabel, circleView.frame.size.width/2, self.mapWebView.frame.size.width > self.mapWebView.frame.size.height? sizeLabel: sizeLabel-sizeLabel/3)];
    circleRadiusView.backgroundColor = [UIColor whiteColor];
    circleRadiusView.textColor = [UIColor grayColor];
    [circleRadiusView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:13]];
    circleRadiusView.layer.cornerRadius = 7;
    circleRadiusView.layer.borderWidth = 0.7f;
    circleRadiusView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    circleRadiusView.clipsToBounds = YES;
    
    
    
    
    [self.mapWebView addSubview:circleRadiusView];
    circleRadiusView.userInteractionEnabled=NO;
    
    
    
    [self.mapWebView addSubview:circleView];
    circleView.userInteractionEnabled=NO;
    // smalCircle.center = circleView.center;
    [circleView addSubview:smalCircle];
    
    
    if (clearDarkView) {
        [clearDarkView setFrame:self.mapWebView.bounds];
    }
    
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.mapWebView loadRequest:
     [NSURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://grope.io/maps/?t=%lu",time(NULL)] ] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0]
     ];
    
    
    [self addCircleView];
    
    
    if (clearDarkView) {
        [clearDarkView removeFromSuperview];
    }
    
    clearDarkView = [[UIView alloc]initWithFrame:self.mapWebView.bounds];
    clearDarkView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    
    [clearDarkView setHidden:YES];
    [self.mapWebView addSubview:clearDarkView];
    
    
    
    
    
}

- (void) setTitleInfoWith:(NSString *)click_id {
    
    
    NSString* js=[NSString stringWithFormat:@"showInfoWindowForClickId('%@')",click_id];
    [self.mapWebView stringByEvaluatingJavaScriptFromString: js ];
    
}
-(void)insertMarkerToMap:(CLLocationCoordinate2D) coord text:(NSString*) text click_id:(NSString* )click_id title:(NSString *)title {
    NSString* js=[NSString stringWithFormat:@"insertMarkerToMap(%f,%f,'%@','%@','%@');",coord.latitude,coord.longitude, text,title,click_id ];
    [self.mapWebView stringByEvaluatingJavaScriptFromString: js ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_searchBar setPlaceholder:[GLang getString:@"Notes.search.placeholder"]];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    self.mapWebView.userInteractionEnabled = NO;
    self.mapWebView.scalesPageToFit = YES;
    [self.mapWebView setDelegate:self];
    
    self.mapWebView.scrollView.delegate = self;
    
    
    
    
    
    [self.useSwitch setOn:NO];
    
    
    if((self.note.category)&&(![self.useSwitch isOn])) {
        
        [self setCommandAndParamsWithName:self.searchBar.text andCategory:self.note.category];
        
    }
    
}

- (void)panGestureChanged:(UIPanGestureRecognizer *)panGesture
{
    NSLog(@"123");
}

- (void) clearMarkers {
    
    NSString* js=[NSString stringWithFormat:@"clearMarkers();"];
    [self.mapWebView stringByEvaluatingJavaScriptFromString: js ];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // internal://grope.io/bounds_changed/ZOOM/LONG/LAT
    
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
                
                [self.mapWebView stringByEvaluatingJavaScriptFromString:
                 [NSString stringWithFormat:@"createMapWithCoordinates('%f','%f','%d');",last_loc.coordinate.longitude,last_loc.coordinate.latitude,mapRadius]
                 ];
                
                
            }
        }
        
        else if([path isEqualToString:@"/create_map_compelete"]){
            
            [self insertMarkerToMap:last_loc.coordinate text:@"Your here" click_id:@"coords#iam" title:@"You here"];
        }else if([path isEqualToString:@"/fully_loaded"]){
            
            
            [self changeZoomWith:mapRadius];
            
            //First Fully loaded.
        }else{
            
            if([path  hasPrefix:@"/bounds_changed"]) {
                
                NSLog(@"bounds_changed");
                
                
                NSArray *separate = [[NSArray alloc]initWithArray:[path componentsSeparatedByString:@"/"]];
                NSMutableArray *arraySeparate = [[NSMutableArray alloc]init];
                
                for (NSString *string in separate) {
                    [arraySeparate addObject:string];
                }
                
                NSString *zoomL = [arraySeparate objectAtIndex:2];
                zoom = [zoomL integerValue];
                
                NSString *lonL = [arraySeparate objectAtIndex:3];
                lon = [lonL doubleValue];
                
                NSString *latL = [arraySeparate lastObject];
                lat = [latL doubleValue];
                
                [self changeZoomWith:[zoomL integerValue]];
                [self clearMarkers];
                
                if (self.note.category) {
                    
                    [self setCommandAndParamsWithName:_searchBar.text andCategory:self.note.category];
                    
                } else if (![_searchBar.text isEqualToString:@""]) {
                    
                    [self setCommandAndParamsWithName:_searchBar.text andCategory:@""];
                }
                
            }
            else if ([path  hasPrefix:@"/click_to_marker"]) {
                
                NSArray *separate = [[NSArray alloc]initWithArray:[path componentsSeparatedByString:@"/"]];
                NSMutableArray *arraySeparate = [[NSMutableArray alloc]init];
                
                for (NSString *string in separate) {
                    [arraySeparate addObject:string];
                }
                
                NSString *cl_id = [arraySeparate objectAtIndex:2];
                
                [self setTitleInfoWith:cl_id];
                
                
            }
            // [[[UIAlertView alloc]initWithTitle:@"Alert" message:[[request URL]path] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil]show];
        }
        
        return NO;
    }
    
    
    if(strstr([[[request URL]host] UTF8String],"grope.io")==0){
        [[UIApplication sharedApplication]openURL:[request URL]];
        return false;
    }
    return true;
    
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
    // starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.mapWebView setUserInteractionEnabled: NO];
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    
    NSLog(@"webViewDidFinishLoad");
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.mapWebView setUserInteractionEnabled: YES];
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"didFailLoadWithError %@",error);
    
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

- (IBAction)useSwitchChanged:(UISwitch *)sender
{
    if ((self.searchBar.text)&&(![sender isOn])) {
        
        [self setCommandAndParamsWithName:self.searchBar.text andCategory:self.note.category==nil?@"":self.note.category];
        
    }
    NSLog(@"koncheniy swith is hnached %i", sender.isOn);
    if (!sender.isOn) {
        [clearDarkView setHidden:YES];
        // [self.mapWebView bringSubviewToFront:clearDarkView];
        
    } else {
        [clearDarkView setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) jsonParseForDraw:(id)responce {
    
    if ([responce isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSArray *arrayResp= responce;
    
    
    for (int i = 0; i<[arrayResp count]; i++) {
        
        NSDictionary *dictResponce = [arrayResp objectAtIndex:i];
        NSDictionary * loc_dict=[[dictResponce objectForKey:@"geometry"] objectForKey:@"location"];
        
        
        CLLocation *location=[[CLLocation alloc]initWithLatitude:[[loc_dict objectForKey:@"lat"] floatValue] longitude:[[loc_dict objectForKey:@"lng"] floatValue]];
        
        [self insertMarkerToMap:location.coordinate text:[dictResponce objectForKey:@"name"] click_id:[self createRandomName] title:[dictResponce objectForKey:@"name"]];
        
        
    }
    
}

- (NSString *)createRandomName
{
    NSTimeInterval timeStamp = [ [ NSDate date ] timeIntervalSince1970 ];
    NSString *randomName = [ NSString stringWithFormat:@"%f", timeStamp];
    randomName = [ randomName stringByReplacingOccurrencesOfString:@"." withString:@"" ];
    return randomName;
}

- (void) setCommandAndParamsWithName:(NSString *)name andCategory:(NSString *)category{
    
    NSString *command = [NSString stringWithFormat:@"%@%@", serverURL, placesCommand];
    
    //    AppDelegate* app=[[UIApplication sharedApplication] delegate];
    //    CLLocation * last_loc= [[app locationProvider]lastCoordinates];
    
    
    // NSMutableDictionary *params = [@{@"lng":[NSString stringWithFormat:@"%f",last_loc.coordinate.longitude], @"lat":[NSString stringWithFormat:@"%f",last_loc.coordinate.latitude], @"radius":[NSString stringWithFormat:@"%d",radiusCircle]} mutableCopy];
    NSMutableDictionary *params = [@{@"lng":[NSString stringWithFormat:@"%f",lon], @"lat":[NSString stringWithFormat:@"%f",lat], @"radius":[NSString stringWithFormat:@"%d",radiusCircle]} mutableCopy];
    
    [params setValue:[NSString stringWithString:name] forKey:@"name"];
    [params setValue:[NSString stringWithString:category] forKey:@"category"];
    
    
    URLNetworkHelper *networkHelper = [[URLNetworkHelper alloc] init];
    [networkHelper command:command params:params completionBlock:^(id responce, NSError *error) {
        
        NSLog(@"%@",responce);
        
        [self jsonParseForDraw:responce];
        
    }];
    
}
#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"textDidChange %@",searchText);
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if ([self.useSwitch isOn]) {
        return;
    } else {
        [self clearMarkers];
        if (self.note.category) {
            
            [self setCommandAndParamsWithName:searchBar.text andCategory:self.note.category];
            
        } else if (![searchBar.text isEqualToString:@""]) {
            
            [self setCommandAndParamsWithName:searchBar.text andCategory:@""];
        }
    }
    
    
    
    //    NSString *command = [NSString stringWithFormat:@"%@%@", serverURL, placesCommand];
    //    NSMutableDictionary *params = [@{@"lng":@"37.618423", @"lat":@"55.751244", @"radius":@"10000"} mutableCopy];
    //    [params setValue:[NSString stringWithString:searchBar.text] forKey:@"name"];
    //
    //
    //    URLNetworkHelper *networkHelper = [[URLNetworkHelper alloc] init];
    //    [networkHelper command:command params:params completionBlock:^(id responce, NSError *error) {
    //        NSLog(@"%@",responce);
    //    }];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)aSearchBar {
    
    [aSearchBar setShowsCancelButton:YES animated:YES];
    
    UIView* view=aSearchBar.subviews[0];
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton*)subView;
            
            [cancelButton setTitle:[GLang getString: @"Places.searchBar.title"] forState:UIControlStateNormal];
        }
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
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
