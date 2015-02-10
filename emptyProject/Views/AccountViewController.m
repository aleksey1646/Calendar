//
//  AccountViewController.m
//  emptyProject
//
//  Created by A.O. on 19.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "AccountViewController.h"
#import "AppDelegate.h"

@interface AccountViewController ()

@end

@implementation AccountViewController
@synthesize tableView;
-(void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSString* ident=[[[[mainTab objectAtIndex:[indexPath section]] objectForKey:@"cells"] objectAtIndex: [indexPath row] ] objectForKey:@"ident"];
    [[tableView_ cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
    
    if([ident isEqualToString:@"sign_in"]){
        currentPage=AccountViewControllerPage_SignIn;
        [self onAccountStatusChanged];
    }else if([ident isEqualToString:@"sign_up"]){
        currentPage=AccountViewControllerPage_SignUp;
        [self onAccountStatusChanged];
    }
    
    AppDelegate* app=[[UIApplication sharedApplication] delegate];
    [app notify:@"notify from Account Controller"];
}

-(void)onAccountStatusChanged{
    return;
    if(currentPage==AccountViewControllerPage_Default){
    [mainTab removeAllObjects];
    [mainTab addObject:@{@"cells":
         [NSArray arrayWithObjects:
          @{@"title": [GLang getString:@"Account.sign_in"], @"style":@"UITableViewCellStyleDefault",@"type":@"arrow",@"ident":@"sign_in"},
          @{@"title": [GLang getString:@"Account.sign_up"], @"style":@"UITableViewCellStyleDefault",@"type":@"arrow",@"ident":@"sign_up"},
          nil]}];
          [tableView setExtendedDataSource: mainTab ];
    }else if(currentPage==AccountViewControllerPage_SignIn){
        NSMutableArray* mainTab2=[[NSMutableArray alloc]init];
        [mainTab2 addObject:@{@"cells":
         [NSArray arrayWithObjects:
          @{@"title": [GLang getString:@"Account.login"], @"style":@"UITableViewCellStyleDefault",@"type":@"arrow",@"ident":@"sign_in"},
          @{@"title": [GLang getString:@"Account.password"], @"style":@"UITableViewCellStyleDefault",@"type":@"arrow",@"ident":@"sign_up"},
          nil]}];
        
        AccountViewController* htmlctl=[self.storyboard instantiateViewControllerWithIdentifier:@"AccountStoryboard"];
        [[htmlctl tableView]setExtendedDataSource:mainTab2];
        [self.navigationController pushViewController: htmlctl  animated:YES];
        
    }else if(currentPage==AccountViewControllerPage_SignUp){
        NSMutableArray* mainTab2=[[NSMutableArray alloc]init];
        [mainTab2 addObject:@{@"cells":
         [NSArray arrayWithObjects:
          @{@"title": [GLang getString:@"Account.firstname"], @"style":@"UITableViewCellStyleDefault",@"type":@"arrow",@"ident":@"sign_in"},
          @{@"title": [GLang getString:@"Account.lastname"], @"style":@"UITableViewCellStyleDefault",@"type":@"arrow",@"ident":@"sign_up"},
          nil]}];

        AccountViewController* htmlctl=[self.storyboard instantiateViewControllerWithIdentifier:@"AccountStoryboard"];
        [[htmlctl tableView]setExtendedDataSource:mainTab2];
        [self.navigationController pushViewController: htmlctl  animated:YES];

    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [tableView setDelegate:self];
    [self.navigationItem setTitle:@"Account.title"];
    
    mainTab=[[NSMutableArray alloc]init];
 
    [self.navigationItem setTitle: [GLang getString:@"Settings.title"] ];
    
    currentPage=AccountViewControllerPage_Default;
    [self onAccountStatusChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
