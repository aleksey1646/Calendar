//
//  SettingsViewController.h
//  emptyProject
//
//  Created by A.O. on 05.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "SubTabBarViewController.h"
#import "UIExtendedTableView.h"
@interface SettingsViewController : SubTabBarViewController<UITableViewDelegate>{
    NSMutableArray* mainTab;
}
@property IBOutlet UIExtendedTableView* tableView;
@end
