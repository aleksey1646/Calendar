//
//  NotesPageViewController.h
//  emptyProject
//
//  Created by A.O. on 04.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubTabBarViewController.h"
#import "GLang.h"
#import "AppDelegate.h"
#import "Note.h"
#import "UIExtendedTableView.h"

@interface NotesDataSource : NSObject <UITableViewDelegate>

@property (retain) id notesPageCtrl;
@end


@interface NotesPageViewController : SubTabBarViewController <UISearchBarDelegate>
{
    NSPredicate *predicateString;
}


@property IBOutlet UIExtendedTableView* notesTableView;
@property IBOutlet UISegmentedControl* segmentControl;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray *arrayNotes;
@property (strong) NSMutableString *textSearch;


-(IBAction) segmentChanged:(UISegmentedControl*)sender;
-(IBAction) editClicked;

@property (retain) NotesDataSource * notesDataSource;
@end
//@property IBOutlet UIExtendedTableView* notesTableView;