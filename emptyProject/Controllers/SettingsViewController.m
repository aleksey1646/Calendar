//
//  SettingsViewController.m
//  emptyProject
//
//  Created by A.O. on 05.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "SettingsViewController.h"
#import "GLang.h"
#import "HTMLViewController.h"
#import "SelectSoundViewController.h"
#import "AccountViewController.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize tableView;
-(void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* ident=[[[[mainTab objectAtIndex:[indexPath section]] objectForKey:@"cells"] objectAtIndex: [indexPath row] ] objectForKey:@"ident"];
    
    if([ident isEqualToString:@"clearcache"]){
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [[[UIAlertView alloc]initWithTitle:[GLang getString:@"Settings.clearcache.title"] message:[GLang getString:@"Settings.clearcache.description"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil] show];
    }else if([ident isEqualToString:@"clearentries"]){
        [[[UIAlertView alloc]initWithTitle:[GLang getString:@"Settings.clearentries.title"] message:[GLang getString:@"Settings.clearentries.description"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK",nil] show];
    }else if([ident isEqualToString:@"privacy"]){
        HTMLViewController* htmlctl=[self.storyboard instantiateViewControllerWithIdentifier:@"HTMLViewController"];
        [htmlctl setURL:@"http://www.gnu.org/licenses/gpl-3.0.txt"];
        [htmlctl.navigationItem setTitle:[GLang getString:@"Settings.privacy"]];
        [self.navigationController pushViewController: htmlctl  animated:YES];
    }else if([ident isEqualToString:@"termtouse"]){
        HTMLViewController* htmlctl=[self.storyboard instantiateViewControllerWithIdentifier:@"HTMLViewController"];
        [htmlctl setURL:@"http://www.gnu.org/licenses/gpl-3.0.txt"];
        [htmlctl.navigationItem setTitle:[GLang getString:@"Settings.termtouse"]];
        [self.navigationController pushViewController: htmlctl  animated:YES];
    }else if([ident isEqualToString:@"sound"]){
        SelectSoundViewController* htmlctl=[self.storyboard instantiateViewControllerWithIdentifier:@"SelectSound"];
        [self.navigationController pushViewController: htmlctl  animated:YES];
    }else if([ident isEqualToString:@"account"]){
        AccountViewController* htmlctl=[self.storyboard instantiateViewControllerWithIdentifier:@"AccountStoryboard"];
        [self.navigationController pushViewController: htmlctl  animated:YES];
    }
    
    [[tableView_ cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [tableView setDelegate:self];
    
    mainTab=[[NSMutableArray alloc]init];
    
    [mainTab addObject:@{ @"header_title": [GLang getString:@"Settings.category.account" ],@"cells":
    [NSArray arrayWithObjects:
    @{@"title": [GLang getString:@"Settings.account"], @"ident":@"account", @"style":@"UITableViewCellStyleDefault",@"type":@"arrow"},
    nil]}];
    
    [mainTab addObject:@{ @"header_title": [GLang getString:@"Settings.category.sound" ],@"cells":
    [NSArray arrayWithObjects:
    @{@"title": [GLang getString:@"Settings.tune"], @"style":@"UITableViewCellStyleValue1",@"description":[GLang getString:@"SelectSound.sound_system"],@"type":@"arrow",@"ident":@"sound"},
    @{@"title": [GLang getString:@"Settings.mute"], @"style":@"UITableViewCellStyleDefault",@"type":@"switch"},
    nil]}];

    [mainTab addObject:@{ @"header_title": [GLang getString:@"Settings.category.service" ],@"cells":
    [NSArray arrayWithObjects:
    @{@"title": [GLang getString:@"Settings.clearcache"],@"ident":@"clearcache", @"style":@"UITableViewCellStyleDefault",@"type":@"default"},
    @{@"title": [GLang getString:@"Settings.deletenotes"],@"ident":@"clearentries",  @"style":@"UITableViewCellStyleDefault",@"type":@"default"},
    nil]}];

    [mainTab addObject:@{ @"header_title": [GLang getString:@"Settings.category.terms" ],@"cells":
  [NSArray arrayWithObjects:
   @{@"title": [GLang getString:@"Settings.privacy"],@"ident":@"privacy", @"style":@"UITableViewCellStyleDefault",@"type":@"arrow"},
   @{@"title": [GLang getString:@"Settings.termtouse"],@"ident":@"termtouse", @"style":@"UITableViewCellStyleDefault",@"type":@"arrow"},
   nil]}];
    
    [tableView setExtendedDataSource: mainTab ];

    [self.navigationItem setTitle: [GLang getString:@"Settings.title"] ];

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
