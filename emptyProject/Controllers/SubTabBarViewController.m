//
//  SubTabBarViewController.m
//  emptyProject
//
//  Created by A.O. on 04.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "SubTabBarViewController.h"

@interface SubTabBarViewController ()

@end

@implementation SubTabBarViewController

-(void)viewDidAppear:(BOOL)animated{
    self.parentViewController.navigationItem.title=self.navigationItem.title;
    [self.parentViewController.navigationItem setRightBarButtonItem:self.navigationItem.rightBarButtonItem];
    [self.parentViewController.navigationItem setLeftBarButtonItem:self.navigationItem.leftBarButtonItem];
    
//    self.parentViewController.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self.navigationItem.rightBarButtonItem.target action:self.navigationItem.rightBarButtonItem.action];
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
