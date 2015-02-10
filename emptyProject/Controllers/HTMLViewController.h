//
//  HTMLViewController.h
//  emptyProject
//
//  Created by A.O. on 19.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTMLViewController : UIViewController{
    NSString* loadURL;
    NSString* loadHTML;
    NSString* loadHTMLBase;
}
-(void)setHtmlText:(NSString *)str baseURL:(NSString *)bu;
-(void)setURL:(NSString *)url;

@property IBOutlet UIWebView* webview;
@end
