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

@interface SelectDatesAndTimeController : UIViewController<UITableViewDelegate,UIGCalendarDelegate>{
    UIGCalendar* gcalendar;
    ClockView* gclock;
    UIExtendedTableView* uitableview;
    NSArray* extds;
    UILabel* daysFooterLabel;
}

@property IBOutlet UISegmentedControl* segmentControl;
@property IBOutlet UIView* cw;

-(IBAction)onSegmentClick:(id)sender;


@end
