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
@interface EditCreateViewController : SubTabBarViewController<UITableViewDelegate>{
    //IBOutlet UIExtendedTableView* tableView;
}
@property (retain,nonatomic) IBOutlet UIExtendedTableView* tableView;

@end
