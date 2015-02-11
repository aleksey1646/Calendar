//
//  EditCreateViewController.m
//  emptyProject
//
//  Created by A.O. on 04.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "EditCreateViewController.h"
#import "GLang.h"
#import "NoteTableViewCell.h"
@implementation EditCreateViewController

@synthesize tableView;

- (void)tableView:(UIExtendedTableView *)tableView_local didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* d=[tableView_local extendedDictionaryForIndexPath:indexPath];
    
    NSDictionary* drow_ident=[d objectForKey:@"ident"];
    if(d && drow_ident){//date
        if([drow_ident isEqual:@"date"]){
            [self.navigationController pushViewController: [self.storyboard instantiateViewControllerWithIdentifier:@"SeletedDatesVIewStoryboardID"]  animated:YES];
        }
    }
    
}

-(void)doneButtonClicked:(id)sender{
    NSLog(@"doneButtonClicked");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
        NSLog(@"scrollViewDidEndDecelerating");
        scrollView = self.tableView;
        
        
        NSLog(@"%f",scrollView.contentOffset.y);
        
        CGRect aRect = scrollView.frame;
        NoteTableViewCell *cell = [[NoteTableViewCell alloc]init];
    
        aRect.size.height -= self.keyboardSize.height;
    
        CGRect cellFrameWithoutContentOffSet =  cell.frame;
    
        cellFrameWithoutContentOffSet.origin.y -= scrollView.contentOffset.y;
    
    if (!CGRectContainsRect(aRect, cellFrameWithoutContentOffSet))
    {
        float pointToScrollY = scrollView.contentOffset.y + _keyboardSize.height;
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x,
                                                           pointToScrollY) animated:YES];
    }
    
    }

- (void)keyboardWillShow:(NSNotification *)notification
{
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    _keyboardSize = keyboardSize;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [tableView setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    
    NSMutableArray* mainTab=[[NSMutableArray alloc]init];
    
    [mainTab addObject:@{ @"header_title": [GLang getString:@"EditCreate.category.task" ],@"cells":
  [NSArray arrayWithObjects:
   @{@"title": [GLang getString:@"EditCreate.place"], @"style":@"UITableViewCellStyleDefault",@"description":@"Auto",@"type":@"arrow"},
   @{@"title": [GLang getString:@"EditCreate.date"], @"ident":@"date", @"style":@"UITableViewCellStyleDefault",@"description":@"Fixed",@"type":@"arrow"},
   
   nil]}];
    
    [mainTab addObject:@{ @"header_title": [GLang getString:@"EditCreate.category.alerts" ],@"cells":
                              [NSArray arrayWithObjects:
  @{@"title": [GLang getString:@"EditCreate.place_alert"], @"style":@"UITableViewCellStyleDefault",@"type":@"switch"},
  @{@"title": [GLang getString:@"EditCreate.time_alert"], @"style":@"UITableViewCellStyleDefault",@"type":@"switch"},
                               nil]}];


    [mainTab addObject:@{ @"header_title": [GLang getString:@"EditCreate.category.status" ],@"cells":
                              [NSArray arrayWithObjects:
                               @{@"title": [GLang getString:@"EditCreate.pause"], @"style":@"UITableViewCellStyleDefault",@"type":@"switch"},
                               @{@"title": [GLang getString:@"EditCreate.complete"], @"style":@"UITableViewCellStyleDefault",@"type":@"switch"},
                               nil]}];
    // новая секция note
    
    [mainTab addObject:@{ @"header_title": [GLang getString:@"EditCreate.category.note" ],@"cells":
                              [NSArray arrayWithObjects:
                               @{@"title": [GLang getString:@"EditCreate.note"], @"style":@"UITableViewCellStyleDefault",@"description":@"Insert value",@"type":@"arrow", @"height":@"182"},
                               nil]}];
    
    [tableView setExtendedDataSource: mainTab ];

    [self.navigationItem setTitle:[GLang getString:@"EditCreate.create.title"]];
    [self.navigationItem setTitle:[GLang getString:@"EditCreate.edit.title"]];
    
    //
    UIBarButtonItem *rib=[[UIBarButtonItem alloc] initWithTitle: [GLang getString: @"EditCreate.create_btn" ] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonClicked:)];
                          

    
    
    [self.navigationItem setRightBarButtonItem:rib];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UTableView delegate

- (CGFloat)tableView:(UIExtendedTableView *)tableView_local heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIExtendedDataSource dataSource = tableView_local.privateDataSource.dataSource;
    NSDictionary *dic = [dataSource objectAtIndex:indexPath.section];
    NSDictionary *cellDiscription = [[dic objectForKey:@"cells"] objectAtIndex:indexPath.row];
    if ([cellDiscription objectForKey:@"height"]) {
        return [[cellDiscription objectForKey:@"height"] intValue];
    }
    
    return 45.0f;
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
