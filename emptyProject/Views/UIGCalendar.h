//
//  UIGCalendar.h
//  emptyProject
//
//  Created by A.O. on 07.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGCalendarYearTmp.h"
#import "UIGCalendarMonthTmp.h"

@class UIGCalendar;

@protocol UIGCalendarDelegate <NSObject>
-(void) GCalendarDelegate:(UIGCalendar*)cal onDoubleTap:(UIGCalendarMonthTmp*)cl;
-(void) GCalendarDelegate:(UIGCalendar *)cal onOnceTap:(UIGCalendarMonthTmp *)cl;

@end

@interface UIGCalendar : UIScrollView<UIGCalendarYearFastDelegate>{
    CGFloat previousW;
}

@property long currentYear;
@property long currentMonth;
@property bool firstRst;
@property NSMutableArray* calendars;
@property id<UIGCalendarDelegate> GCalendarDelegate;
@end
