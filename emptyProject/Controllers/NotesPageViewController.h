//
//  NotesPageViewController.h
//  emptyProject
//
//  Created by A.O. on 04.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubTabBarViewController.h"
#import "UIExtendedTableView.h"
#import "GLang.h"

@interface NotesDataSource : NSObject <UITableViewDelegate>

@property (retain) id notesPageCtrl;
@end


@interface NotesPageViewController : SubTabBarViewController
{
}
@property IBOutlet UIExtendedTableView* notesTableView;
@property IBOutlet UISegmentedControl* segmentControl;
-(IBAction) segmentChanged:(UISegmentedControl*)sender;
-(IBAction) editClicked;

@property (retain) NotesDataSource * notesDataSource;
@end
