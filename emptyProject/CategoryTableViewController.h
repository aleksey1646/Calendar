//
//  CategoryTableViewController.h
//  emptyProject
//
//  Created by Katushka Mazalova on 02.03.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
@interface CategoryTableViewController : UITableViewController

@property (strong)  NSMutableArray *arrayWithJsonCategory;
@property (weak) Note *note;

@end
