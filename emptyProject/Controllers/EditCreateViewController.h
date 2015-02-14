//
//  EditCreateViewController.h
//  emptyProject
//
//  Created by A.O. on 04.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubTabBarViewController.h"
#import "UIExtendedTableView.h"
#import "AppDelegate.h"//???
@interface EditCreateViewController : SubTabBarViewController<UITableViewDelegate,UIScrollViewDelegate,NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController *fetchedResultsController;
   // NSManagedObjectContext *managedObjectContext;
    
    //IBOutlet UIExtendedTableView* tableView;
}
@property (retain,nonatomic) IBOutlet UIExtendedTableView* tableView;
@property (assign) CGSize keyboardSize;


@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
