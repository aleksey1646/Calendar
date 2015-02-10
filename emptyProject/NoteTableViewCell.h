//
//  NoteTableViewCell.h
//  emptyProject
//
//  Created by Katushka Mazalova on 07.02.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIExtendedTableView.h"

@interface NoteTableViewCell : UITableViewCell <UITableViewDelegate,UITextViewDelegate>

@property (weak,nonatomic) UIExtendedTableView *tableView;
@property (weak,nonatomic) UITextView *textView;


@end
