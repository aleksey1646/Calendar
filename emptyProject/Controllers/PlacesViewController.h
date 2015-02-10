//
//  PlacesViewController.h
//  emptyProject
//
//  Created by A.O. on 05.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "SubTabBarViewController.h"

@interface PlacesViewController : SubTabBarViewController<UIWebViewDelegate>

@property IBOutlet UIWebView *webView;
@property IBOutlet UISegmentedControl * segmentcontrol;
@end
