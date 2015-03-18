//
//  NotesPageViewController.m
//  emptyProject
//
//  Created by A.O. on 04.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "NotesPageViewController.h"
#import "AppDelegate.h"
#import "EditCreateViewController.h"
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

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"Remove";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath");
    NotesPageViewController* pctl=[self notesPageCtrl];
    UIViewController *uiv=[[pctl storyboard] instantiateViewControllerWithIdentifier:@"EditCreatePage"];

    AppDelegate *app= (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [app notify:@"Notify From Notes"];
    
    
    //edit selected cells with note
    NSDictionary* sectionDictionary=[pctl.arrayNotes objectAtIndex:[indexPath section]];
    
    Note *selectNoteCell = [[sectionDictionary objectForKey:@"cells"] objectAtIndex:indexPath.row];
    NSLog(@"selectNoteCell");
     NSLog(@"%@",selectNoteCell);
    
    EditCreateViewController *controllerCreateNote = (EditCreateViewController *)uiv;
    controllerCreateNote.note = selectNoteCell;
    
 
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
    
    NSMutableArray *predicateMutableArray = [NSMutableArray array];
    
    //predicate
    if (self.textSearch) {
        NSString *str = self.textSearch;
        
        NSPredicate *predicateSearch = [NSPredicate predicateWithFormat:@"title contains[cd] %@ || textNote contains[cd] %@", str,str];
        
        [predicateMutableArray addObject:predicateSearch];
    }
    if (predicateString) {
        
         [predicateMutableArray addObject:predicateString];
    }
    if ([predicateMutableArray count]!=0) {
        
        NSArray *arrayWithPredicates = [NSArray arrayWithArray:predicateMutableArray];
        NSPredicate * andPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:arrayWithPredicates];//multiple predicate
        
        [request setPredicate:andPredicate];
        
    }
    

    
   
   
    NSError* error = nil;
    NSMutableArray *arrayWithNote = [NSMutableArray array];
    self.arrayNotes = [NSMutableArray array];
    arrayWithNote = [[self.managedObjectContext executeFetchRequest:request error:&error]mutableCopy];
    NSMutableArray *statusPause = [NSMutableArray array];
    NSMutableArray *statusComplete = [NSMutableArray array];
     NSMutableArray *statusActive = [NSMutableArray array];
    for (int i = 0; i<[arrayWithNote count]; i++) {
        Note *nextNote = [arrayWithNote objectAtIndex:i];
        
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
    if ([statusActive count]) {
        [self.arrayNotes addObject:@{ @"cells":statusActive}];
    }
    if ([statusPause count]) {
         [self.arrayNotes addObject:@{@"header_title":@"Приостановленные", @"cells":statusPause}];
    }
    if ([statusComplete count]) {
        [self.arrayNotes addObject:@{@"header_title":@"Выполненные", @"cells":statusComplete}];
    }
 
    
    
    
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
   
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if (!notesTableView.editing) {
        
        item = UIBarButtonSystemItemDone;
        
    }

    if (item == UIBarButtonSystemItemDone) {
        self.navigationItem.leftBarButtonItem.title = @"Edit";
    } else {
        self.navigationItem.leftBarButtonItem.title = @"Done";
    }
   
    
    
    
}

- (NSDate *)getNextDate:(NSDate *)toDate {
    
     NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:1];
    return [gregorian dateByAddingComponents:offsetComponents toDate:toDate options:0];
}

-(IBAction) segmentChanged:(UISegmentedControl*)sender{
    NSLog(@"segment changed to %@",
          [sender titleForSegmentAtIndex: [sender selectedSegmentIndex]]
          );
    //for day and month
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    
    //for week
    NSDate *nextDate = [self getNextDate:currentDate];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d.M.yyyy;"];
    
    
    NSString *stringDayWeek1 = [dateFormat stringFromDate:nextDate];
    NSDate *dateString = [dateFormat dateFromString:stringDayWeek1];
    NSString *stringDayWeek2 = [dateFormat stringFromDate:[self getNextDate:dateString]];
    dateString = [dateFormat dateFromString:stringDayWeek2];
    
    NSString *stringDayWeek3 = [dateFormat stringFromDate:[self getNextDate:dateString]];
    dateString = [dateFormat dateFromString:stringDayWeek3];
    NSString *stringDayWeek4 = [dateFormat stringFromDate:[self getNextDate:dateString]];
    dateString = [dateFormat dateFromString:stringDayWeek4];
    NSString *stringDayWeek5 = [dateFormat stringFromDate:[self getNextDate:dateString]];
    dateString = [dateFormat dateFromString:stringDayWeek5];
    NSString *stringDayWeek6 = [dateFormat stringFromDate:[self getNextDate:dateString]];
    dateString = [dateFormat dateFromString:stringDayWeek6];
    NSString *stringDayWeek7 = [dateFormat stringFromDate:[self getNextDate:dateString]];
    dateString = [dateFormat dateFromString:stringDayWeek7];
    
    
   
    
    
    /*
    NSDateComponents *componentsWeek = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:currentDate];
    int dayofweek = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:currentDate] weekday];//current day of week
    [components setDay:([components day] - ((dayofweek) - 2))];// for beginning of the week.
    NSDate *beginningOfWeek = [gregorian dateFromComponents:componentsWeek];
    NSDateFormatter *dateFormat_first = [[NSDateFormatter alloc] init];
    [dateFormat_first setDateFormat:@"d.M.yyyy;"];
    NSString *dateString2Prev = [dateFormat stringFromDate:beginningOfWeek];
    NSDate *weekstartPrev = [dateFormat_first dateFromString:dateString2Prev];

    NSCalendar *gregorianEnd = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *componentsEnd = [gregorianEnd components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:currentDate];
    int endDayOfWeek = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:currentDate] weekday];//current day of week
    [componentsEnd setDay:([componentsEnd day]+(7-endDayOfWeek)+1)];// for end day of the week
    NSDate *endOfWeek = [gregorianEnd dateFromComponents:componentsEnd];
    NSDateFormatter *dateFormat_End = [[NSDateFormatter alloc] init];
    [dateFormat_End setDateFormat:@"d.M.yyyy;"];
    NSString *dateEndPrev = [dateFormat stringFromDate:endOfWeek];
    NSDate *weekEndPrev7 = [dateFormat_End dateFromString:dateEndPrev];
    
    
    NSDateComponents *componentsYest = [gregorianEnd components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:currentDate];
    [componentsEnd setDay:-1];
    
    NSDate *weekEndPrev6 = [[NSCalendar currentCalendar] dateByAddingComponents:componentsYest toDate:weekEndPrev7 options:0];
    NSString *dateWeekEndPrev6 = [dateFormat stringFromDate:weekEndPrev6];
    */


    [components month];
    [components day];
    [components year];
    if ([sender selectedSegmentIndex]==0) {
        
        NSString *match = [NSString stringWithFormat:@"*%ld.%ld.%ld;*",[components day],[components month],[components year]];
        
        predicateString = [NSPredicate predicateWithFormat:@"date like %@",match];
        
        
    } else if([sender selectedSegmentIndex]==1) {
        
        NSString *match1 = [NSString stringWithFormat:@"*%@*",stringDayWeek1];
        NSString *match2 = [NSString stringWithFormat:@"*%@*",stringDayWeek2];
        NSString *match3 = [NSString stringWithFormat:@"*%@*",stringDayWeek3];
        NSString *match4 = [NSString stringWithFormat:@"*%@*",stringDayWeek4];
        NSString *match5 = [NSString stringWithFormat:@"*%@*",stringDayWeek5];
        NSString *match6 = [NSString stringWithFormat:@"*%@*",stringDayWeek6];
        NSString *match7 = [NSString stringWithFormat:@"*%@*",stringDayWeek7];
        
        predicateString = [NSPredicate predicateWithFormat:@"(date like %@) OR (date like %@) OR (date like %@) OR (date like %@) OR (date like %@) OR (date like %@) OR (date like %@)",match1,match2,match3,match4,match5,match6,match7];
       
    }
    else if([sender selectedSegmentIndex]==2) {
       
        NSString *match = [NSString stringWithFormat:@"*.%ld.%ld;*",[components month],[components year]];
        
        predicateString = [NSPredicate predicateWithFormat:@"date like %@",match];

    }
    
    else if ([sender selectedSegmentIndex]==3) {
        
        predicateString = nil;
    }
   [notesTableView setExtendedDataSource:[self getAllNotes]];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (![searchText isEqualToString:@""]) {
        self.textSearch = (NSMutableString *)searchText;
    } else {
         self.textSearch = nil;
    }
    
    [notesTableView setExtendedDataSource:[self getAllNotes]];
    NSLog(@" search text %@", self.textSearch);
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    

}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)aSearchBar {
    
    [aSearchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [self.view endEditing:YES];
}

#pragma mark - viewDidLoad
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
    
    search_bar.delegate = self;
    [notesTableView setTableHeaderView:search_bar];
    

    [notesTableView setExtendedDataSource:[self getAllNotes]];

    [segmentControl setTitle:[GLang getString:@"Notes.segments.today"]  forSegmentAtIndex:0];
    [segmentControl setTitle:[GLang getString:@"Notes.segments.week"]  forSegmentAtIndex:1];
    [segmentControl setTitle:[GLang getString:@"Notes.segments.month"]  forSegmentAtIndex:2];
    [segmentControl setTitle:[GLang getString:@"Notes.segments.all"]  forSegmentAtIndex:3];
    [segmentControl setSelectedSegmentIndex:3];
    
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
