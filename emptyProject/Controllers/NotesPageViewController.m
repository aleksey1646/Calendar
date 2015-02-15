//
//  NotesPageViewController.m
//  emptyProject
//
//  Created by A.O. on 04.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "NotesPageViewController.h"
#import "AppDelegate.h"

bool firstLoadHideSearch=false;
bool editMode=false;

@implementation NotesDataSource
@synthesize notesPageCtrl;

CGFloat NotesDataSourceHeightForRow;

+(void)initialize{
    CGSize st=[@"H" sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
    CGSize sd=[@"A\nB\nC\nEL\nEL" sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]}];
    NotesDataSourceHeightForRow= st.height+sd.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath");
    NotesPageViewController* pctl=[self notesPageCtrl];
    UIViewController *uiv=[[pctl storyboard] instantiateViewControllerWithIdentifier:@"EditCreatePage"];

    AppDelegate *app= (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [app notify:@"Notify From Notes"];
    
    
    //UINavigationController *rootNavCtrl=(UINavigationController*)pctl.view.window.rootViewController;
    //[rootNavCtrl pushViewController:uiv animated:YES];
 
    UITabBarController *tabbar_controller=(UITabBarController*)pctl.parentViewController;
    [tabbar_controller showViewController:uiv sender:self];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row]==0){
        if(firstLoadHideSearch){return;}
        firstLoadHideSearch=true;
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NotesDataSourceHeightForRow;
}

@end





@implementation NotesPageViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize notesTableView,notesDataSource,segmentControl;

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [notesTableView setExtendedDataSource:[self getAllNotes]];

}
#pragma mark - Get notes from CoreData

- (NSMutableArray *) getAllNotes {
    
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"Note"
                                                   inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    
    NSError* error = nil;
    NSMutableArray *arrayWithNote = [NSMutableArray array];
    self.arrayNotes = [NSMutableArray array];
    arrayWithNote = [[self.managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
    NSMutableArray *statusPause = [NSMutableArray array];
    NSMutableArray *statusComplete = [NSMutableArray array];
     NSMutableArray *statusActive = [NSMutableArray array];
    for (int i = 0; i<[arrayWithNote count]; i++) {
        Note *nextNote = [arrayWithNote objectAtIndex:i];
    //for (Note *nextNote in self.arrayNotes) {
        
        if ([nextNote.statusPause boolValue]) { // или не statusComplete, но дата прошла
            [statusPause addObject:nextNote];
        } else {
        if ([nextNote.statusComplete boolValue]) {
            [statusComplete addObject:nextNote];
        } else {
            [statusActive addObject:nextNote];
        }
        }
        
    }
   // [self.arrayNotes addObject:@{@"header_title":@"Активные", @"cells":statusActive}];
    [self.arrayNotes addObject:@{ @"cells":statusActive}];
    [self.arrayNotes addObject:@{@"header_title":@"Приостановленные", @"cells":statusPause}];
    [self.arrayNotes addObject:@{@"header_title":@"Выполненные", @"cells":statusComplete}];
    
    if (error) {
        
        NSLog(@"ERROR! %@",[error localizedDescription]);
        
    }
    NSLog(@"array notes%@",self.arrayNotes);
    [notesTableView reloadData];
    return self.arrayNotes;
   
    
}

-(IBAction) editClicked{
    NSLog(@"Edit button click");
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         self.tabBarController.tabBar.alpha=0;
                         if(editMode){
                             self.tabBarController.tabBar.alpha=1;
                         }else{
                             self.tabBarController.tabBar.alpha=0;
                         }
                     }
                     completion:NULL];
    
    editMode=!editMode;
    [notesTableView setEditing:editMode animated:YES];
}

-(IBAction) segmentChanged:(UISegmentedControl*)sender{
    NSLog(@"segment changed to %@",
          [sender titleForSegmentAtIndex: [sender selectedSegmentIndex]]
          );
}

- (void)viewDidLoad {
    NSLog(@"NotesPageViewController::viewDidLoad");
    [super viewDidLoad];
    
    AppDelegate *appDelegate =  [[UIApplication sharedApplication]delegate];
    self.managedObjectContext=[appDelegate managedObjectContext];

    [self setNotesDataSource: [[NotesDataSource alloc]init] ];
    [[self notesDataSource] setNotesPageCtrl:self];
    [notesTableView setDelegate:notesDataSource];
    
    UISearchBar * search_bar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 0, 50)];
    [search_bar setPlaceholder:[GLang getString:@"Notes.search.placeholder"]];
    
    [notesTableView setTableHeaderView:search_bar];
    
    //[self getAllNotes];
    //nea
    /*
    NSMutableArray* ara=[[NSMutableArray alloc]init];
    
    //temp
    NSMutableArray* tableRows=nil;
    tableRows=[[NSMutableArray alloc]init];
    for(int i=0;i<5;i++){
     [tableRows addObject:
      [NSDictionary dictionaryWithObjectsAndKeys:[GLang getString:@"Notes.temp.place"],@"title",@"4",@"description_lines",@"UITableViewCellStyleSubtitle",@"style",[GLang getString:@"Notes.temp.descr"],@"description",@"arrow",@"type", @"NSLineBreakByWordWrapping",@"description_linebreak", nil]
      ];
    }
    [ara addObject:@{ @"cells":tableRows}];

    tableRows=[[NSMutableArray alloc]init];
    for(int i=0;i<10;i++){
        [tableRows addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:[GLang getString:@"Notes.temp.place"],@"title",@"4",@"description_lines",@"UITableViewCellStyleSubtitle",@"style",[GLang getString:@"Notes.temp.descr"],@"description",@"arrow",@"type", @"NSLineBreakByWordWrapping",@"description_linebreak", nil]
         ];
    }
    [ara addObject:@{@"header_title":@"Выполненные", @"cells":tableRows}];

    tableRows=[[NSMutableArray alloc]init];
    for(int i=0;i<20;i++){
        [tableRows addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:[GLang getString:@"Notes.temp.place"],@"title",@"4",@"description_lines",@"UITableViewCellStyleSubtitle",@"style",[GLang getString:@"Notes.temp.descr"],@"description",@"arrow",@"type", @"NSLineBreakByWordWrapping",@"description_linebreak", nil]
         ];
    }
    [ara addObject:@{@"header_title":@"Экспиред", @"cells":tableRows}];
     [notesTableView setExtendedDataSource: ara];

    */
    //end of temp
    
    
    [notesTableView setExtendedDataSource:[self getAllNotes]];
    
//    [segmentControl setTitle:[GLang getString:@"Notes.segments.here"]  forSegmentAtIndex:0];
    [segmentControl setTitle:[GLang getString:@"Notes.segments.today"]  forSegmentAtIndex:0];
    [segmentControl setTitle:[GLang getString:@"Notes.segments.week"]  forSegmentAtIndex:1];
    [segmentControl setTitle:[GLang getString:@"Notes.segments.month"]  forSegmentAtIndex:2];
    [segmentControl setTitle:[GLang getString:@"Notes.segments.all"]  forSegmentAtIndex:3];
    
    [self.navigationItem setTitle: [GLang getString:@"Notes.title"] ];
    [self.navigationItem.leftBarButtonItem setTitle: [GLang getString:@"Notes.edit"] ];
    
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
