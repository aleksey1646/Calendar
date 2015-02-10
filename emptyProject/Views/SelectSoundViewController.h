//
//  SelectSoundViewController.h
//  emptyProject
//
//  Created by A.O. on 19.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIExtendedTableView.h"

@interface SelectSoundViewController : UIViewController<UITableViewDelegate>{
    NSMutableArray* mainTab;
}

@property IBOutlet UIExtendedTableView* tableView;
@end
