//
//  SelectSoundViewController.m
//  emptyProject
//
//  Created by A.O. on 19.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "SelectSoundViewController.h"
#import "GLang.h"
#import "AppDelegate.h"
@interface SelectSoundViewController ()

@end

@implementation SelectSoundViewController
@synthesize tableView;
-(void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString* ident=[[[[mainTab objectAtIndex:[indexPath section]] objectForKey:@"cells"] objectAtIndex: [indexPath row] ] objectForKey:@"ident"];
    [[tableView_ cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    AppDelegate* app=[[UIApplication sharedApplication] delegate];
    [app notify:@"notify from SelectSound Controller"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [tableView setDelegate:self];
    [self.navigationItem setTitle:@"SelectSound.title"];
    
    mainTab=[[NSMutableArray alloc]init];
    
    [mainTab addObject:@{@"cells":
                              [NSArray arrayWithObjects:
                               @{@"title": [GLang getString:@"SelectSound.sound_system"], @"style":@"UITableViewCellStyleDefault",@"type":@"checkbox"},
                               nil]}];
    
    [tableView setExtendedDataSource: mainTab ];
    
    [self.navigationItem setTitle: [GLang getString:@"Settings.title"] ];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
