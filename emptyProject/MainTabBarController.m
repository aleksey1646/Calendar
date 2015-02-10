//
//  MainTabBarController.m
//  emptyProject
//
//  Created by A.O. on 18.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "MainTabBarController.h"
#import "GLang.h"
@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self.tabBar.items objectAtIndex:0]  setTitle: [GLang getString:@"Places.tabbar.title"] ];
    [[self.tabBar.items objectAtIndex:1]  setTitle: [GLang getString:@"Notes.tabbar.title"] ];
    [[self.tabBar.items objectAtIndex:2]  setTitle: [GLang getString:@"Settings.tabbar.title"] ];
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
