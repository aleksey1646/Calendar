//
//  AccountViewController.h
//  emptyProject
//
//  Created by A.O. on 19.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIExtendedTableView.h"

typedef  enum {
    AccountViewControllerPage_Default,AccountViewControllerPage_SignIn,AccountViewControllerPage_SignUp
} AccountViewControllerPage_t;

@interface AccountViewController : UIViewController<UITableViewDelegate>{
    NSMutableArray* mainTab;
    AccountViewControllerPage_t currentPage;
}

@property IBOutlet UIExtendedTableView* tableView;

@end
