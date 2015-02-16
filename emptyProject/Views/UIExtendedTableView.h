//
//  UIExtendedTableView.h
//  emptyProject
//
//  Created by A.O. on 05.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//
#import "NoteTableViewCell.h"
#import <UIKit/UIKit.h>
#import "GLang.h"
#import "AppDelegate.h"
#import "Note.h"



typedef NSArray* UIExtendedDataSource;

@interface UIExtendedTableViewPrivateDataSource:NSObject <UITableViewDataSource>{
}
@property (retain,nonatomic) UIExtendedDataSource dataSource;

@property (weak) UISwitch *swithNotifTime;
@property (weak) UISwitch *swithNotifPlace;
@property (weak) UISwitch *swithStatusPause;
@property (weak) UISwitch *swithStatusComplete;

@end



@interface UIExtendedTableView : UITableView {
    
}
@property (retain,nonatomic)    UIExtendedTableViewPrivateDataSource* privateDataSource;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(void)setExtendedDataSource:(UIExtendedDataSource)arrayWithDictionarys;
-(NSDictionary*)extendedDictionaryForIndexPath:(NSIndexPath*)indx;

@end

//@property (weak) NoteTableViewCell *cell;