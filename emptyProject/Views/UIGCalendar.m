//
//  UIGCalendar.m
//  emptyProject
//
//  Created by A.O. on 07.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//


#import "UIGCalendar.h"

@implementation UIGCalendar
@synthesize calendars,currentMonth,currentYear,firstRst,GCalendarDelegate;

-(void)restructIfNeeded{

    @autoreleasepool {
        @synchronized(calendars){
            
            [self setContentSize: CGSizeMake(self.frame.size.width, self.frame.size.height*5) ];
            
            CGFloat contentOffsetStart=self.frame.size.height*2;
            
//            int elementsInRow=1;
            int oneElementSize=self.frame.size.height;
            
            int rowsSkipped;
            if(self.contentOffset.y<contentOffsetStart){
                //scrolled to TOP
                rowsSkipped=-(int)((contentOffsetStart-self.contentOffset.y)/oneElementSize);
            }else{
                rowsSkipped=(int)((self.contentOffset.y-contentOffsetStart)/oneElementSize);
                //scrolled to BOTTOM
            }
            
            if(rowsSkipped!=0 || firstRst || previousW!=self.frame.size.width){
                previousW=self.frame.size.width;
                [self setContentOffset:CGPointMake(0, contentOffsetStart)];
                if(rowsSkipped<0){rowsSkipped=-1;}else{rowsSkipped=1;}
                currentYear+=rowsSkipped;
                int tmp_y=(int)currentYear;
                for(int i=0;i<3;i++){
                    UIGCalendarYearTmp* c=[calendars objectAtIndex:i];
                    [c setFrame:CGRectMake(0, oneElementSize*(i+1), self.frame.size.width, oneElementSize)];
                    [c setYear:tmp_y];
                    tmp_y++;
                }
                
                if(firstRst){firstRst=false;[self setContentOffset:CGPointMake(0, contentOffsetStart)] ;}
                
            }//roow changed
            
        }//sync
    }//apoll
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self restructIfNeeded];
}


-(void)GCalendarYearFastDelegate:(UIGCalendarYearTmp *)yf onDoubleTap:(UIGCalendarMonthTmp *)mf{
    [self.GCalendarDelegate GCalendarDelegate:self onDoubleTap:mf];
//    NSLog(@"GCalendarYearFastDelegate!!!%@",[[mf monthLabel]text]);
}
-(void)GCalendarYearFastDelegate:(UIGCalendarYearTmp *)yf onOnceTap:(UIGCalendarMonthTmp *)mf {
    [self.GCalendarDelegate GCalendarDelegate:self onOnceTap:mf];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(!self){return nil;}
    [self setCalendars:[[NSMutableArray alloc]init]];
    [self setFirstRst:true];
    [self setCurrentMonth:1];
    [self setCurrentYear:2015];
    [self setShowsVerticalScrollIndicator:NO];
    [self setCanCancelContentTouches:YES];
    [self setGCalendarDelegate:nil];
    
    for(int i=0;i<3;i++){
        UIGCalendarYearTmp* c=[[UIGCalendarYearTmp alloc]initWithFrame:CGRectZero];
        [c setYear:(int)currentYear];
        [self addSubview:c];
        [calendars addObject:c];
        [c setGCalendarYearTmpDelegate:self];

    }
    [self restructIfNeeded];
    
    [self setNeedsDisplay];
    return self;
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(!self){return nil;}
    self=[self initWithFrame:CGRectZero];
    return self;
}


@end
