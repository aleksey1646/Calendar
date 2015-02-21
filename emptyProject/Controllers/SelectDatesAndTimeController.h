//
//  SelectDatesAndTimeController.h
//  emptyProject
//
//  Created by A.O. on 11.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIGCalendar.h"
#import "ClockView.h"
#import "UIExtendedTableView.h"
#import "EditCreateViewController.h"
#import "AppDelegate.h"//???
#import "Note.h"


@interface SelectDatesAndTimeController : UIViewController<UITableViewDelegate,UIGCalendarDelegate>{
    UIGCalendar* gcalendar;
    ClockView* gclock;
    UIExtendedTableView* uitableview;
    NSArray* extds;
    UILabel* daysFooterLabel;
}

@property IBOutlet UISegmentedControl* segmentControl;
@property IBOutlet UIView* cw;

@property (weak) Note *note;
@property (nonatomic, strong) NSString *dayWeeks;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(IBAction)onSegmentClick:(id)sender;
-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;


@end
