//
//  HTMLViewController.m
//  emptyProject
//
//  Created by A.O. on 19.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "HTMLViewController.h"

@interface HTMLViewController ()

@end

@implementation HTMLViewController
@synthesize webview;

-(void)upd{
    if(loadHTML){
        [webview loadHTMLString:loadHTML baseURL:  [NSURL URLWithString:loadHTMLBase] ];
    }else if(loadURL){
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:loadURL]]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self upd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setHtmlText:(NSString *)str baseURL:(NSString *)bu{
    loadURL=nil;
    loadHTML=str;
    loadHTMLBase=bu;
    [self upd];
}

-(void)setURL:(NSString *)url{
    loadHTML=loadHTMLBase=nil;
    loadURL=url;
    [self upd];
    
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
