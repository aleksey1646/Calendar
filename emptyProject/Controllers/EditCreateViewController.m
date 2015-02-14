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
#import "Note.h"
#import "SelectDatesAndTimeController.h"

@interface EditCreateViewController ()

@property (strong) Note *note;

@end

//#import "DataManager.h"

@implementation EditCreateViewController

@synthesize managedObjectContext = _managedObjectContext; 
@synthesize tableView,fetchedResultsController;

//#pragma mark - ManagedObjectContext
//
//- (NSManagedObjectContext*) managedObjectContext  {
//    
//    return [[DataManager sharedManager] managedObjectContext];
//}

- (void)tableView:(UIExtendedTableView *)tableView_local didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* d=[tableView_local extendedDictionaryForIndexPath:indexPath];
    
    NSDictionary* drow_ident=[d objectForKey:@"ident"];
    if(d && drow_ident){//date
        if([drow_ident isEqual:@"date"]){
            SelectDatesAndTimeController *selectDatesAndTimeController = [self.storyboard instantiateViewControllerWithIdentifier:@"SeletedDatesVIewStoryboardID"];
            
            
            selectDatesAndTimeController.note = self.note;
            
            
            [self.navigationController pushViewController:selectDatesAndTimeController animated:YES];
        }
    }
    
}
#pragma mark - Add the note

- (Note *) addNote {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:self.managedObjectContext];
    
    Note *object = [[Note alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    return object;
}

-(void)doneButtonClicked:(id)sender{
    
    
    NSError* error = nil;
    
    [self.managedObjectContext insertObject:self.note];
    
    if (![self.managedObjectContext save:&error]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error:" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"%@",[error localizedDescription]);
    } else
    [self.navigationController popViewControllerAnimated:YES];

    NSLog(@"doneButtonClicked");
     
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    _keyboardSize = keyboardSize;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //managedObjectContext same AppDelegate
    
    AppDelegate *appDelegate =  [[UIApplication sharedApplication]delegate];
    self.managedObjectContext=[appDelegate managedObjectContext];
    
    self.note = [self addNote];
    
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
