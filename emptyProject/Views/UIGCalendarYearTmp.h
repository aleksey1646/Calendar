//
//  UIGCalendarYearFast.h
//  emptyProject
//
//  Created by A.O. on 08.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGCalendarMonthTmp.h"


@class UIGCalendarYearTmp;

@protocol UIGCalendarYearFastDelegate <NSObject>
-(void) GCalendarYearFastDelegate:(UIGCalendarYearTmp*)yf onDoubleTap:(UIGCalendarMonthTmp*)mf;
-(void) GCalendarYearFastDelegate:(UIGCalendarYearTmp*)yf onOnceTap:(UIGCalendarMonthTmp*)mf;
@end

@interface UIGCalendarYearTmp : UIView{
    NSMutableArray* calendars;
    NSMutableArray* countYear;
    int currentYear;
}

- (void) setYear:(int)year;
@property UILabel* yearLabel;
@property UILabel* currentYearLabel;
@property UIView* viewUnderline;
@property  id<UIGCalendarYearFastDelegate> GCalendarYearTmpDelegate;

@end
