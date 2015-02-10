//
//  UIExtendedTableView.h
//  emptyProject
//
//  Created by A.O. on 05.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLang.h"

typedef NSArray* UIExtendedDataSource;

@interface UIExtendedTableViewPrivateDataSource:NSObject <UITableViewDataSource>{
}
@property (retain,nonatomic) UIExtendedDataSource dataSource;
@end


@interface UIExtendedTableView : UITableView{
}
@property (retain,nonatomic)    UIExtendedTableViewPrivateDataSource* privateDataSource;
-(void)setExtendedDataSource:(UIExtendedDataSource)arrayWithDictionarys;
-(NSDictionary*)extendedDictionaryForIndexPath:(NSIndexPath*)indx;

@end

