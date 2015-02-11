//
//  UIGCalendarYearFast.m
//  emptyProject
//
//  Created by A.O. on 08.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "UIGCalendarYearTmp.h"
#import "CustomTapGestureRecognizer.h"

@implementation UIGCalendarYearTmp
@synthesize yearLabel,GCalendarYearTmpDelegate, currentYearLabel;

- (void)clickOnMonth:(CustomTapGestureRecognizer*)sender
{
    
    NSLog(@"gesture recognizer tap count: %i", [sender tapCount]);
    
      if([sender tapCount] > 1){
        
        if(GCalendarYearTmpDelegate ){
      
            [GCalendarYearTmpDelegate GCalendarYearFastDelegate:self onDoubleTap:(UIGCalendarMonthTmp*)[sender view]];
            
        }
    } else {
        
        if(GCalendarYearTmpDelegate){
            [GCalendarYearTmpDelegate GCalendarYearFastDelegate:self onOnceTap:(UIGCalendarMonthTmp*)[sender view]];
       
        }
    }
   
}

-(void)restructIfNeeded{
    long elementsInRow;
    long elementRowsInPage;
    
    if(self.frame.size.width>self.frame.size.height){
        //album ______
        elementsInRow=6;
        elementRowsInPage=3;//2
    }else{
        //portait ||
        elementsInRow=3;
        elementRowsInPage=5;//4
    }
    
    
    CGFloat oneElementSize=self.frame.size.height/elementRowsInPage;
    CGFloat oneElementWidth=self.frame.size.width/elementsInRow;
    CGFloat widthOverWidth=oneElementWidth*elementsInRow;
    CGFloat ira_y=0;
    CGFloat ira_x=0;
    CGFloat border=self.frame.size.width/20;
    
    int i;
    int tmp_m=(int)1;
    
    
    
    if (currentYearLabel.superview) {
        [currentYearLabel removeFromSuperview];
    }
        
        currentYearLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [currentYearLabel setFont:[UIFont systemFontOfSize:24]];
        [currentYearLabel setText:[NSString stringWithFormat:@"%d",currentYear]];
        
        [currentYearLabel setFrame:CGRectMake(ira_x+border/2, ira_y, widthOverWidth, oneElementSize/5)];
        [currentYearLabel setTextColor:[UIColor grayColor]];
        
        [self addSubview:currentYearLabel];
    
    
    if (_viewUnderline.superview) {
        [_viewUnderline removeFromSuperview];
    }
   
    _viewUnderline=[[UIView alloc] init];
    
    _viewUnderline.frame=CGRectMake(currentYearLabel.frame.origin.x,currentYearLabel.frame.origin.y+currentYearLabel.frame.size.height+border/2,widthOverWidth,0.5);
                                   
    _viewUnderline.backgroundColor=[UIColor grayColor];
    [self addSubview:_viewUnderline];

    for(i=0;i<12;i++){
        UIGCalendarMonthTmp* cf;
        if([calendars count]<=i){
            cf=[[UIGCalendarMonthTmp alloc]initWithFrame:CGRectZero];
            [cf setFont:[UIFont systemFontOfSize:8]];
            [[cf monthLabel]setFont:[UIFont systemFontOfSize:12]];
            [self addSubview:cf];
            [calendars addObject:cf];
            
            CustomTapGestureRecognizer *double_tap_recognizer;
            double_tap_recognizer = [[CustomTapGestureRecognizer alloc] initWithTarget: self action: @selector (clickOnMonth:)];
            double_tap_recognizer.delaysTouchesEnded = YES;
            [double_tap_recognizer setNumberOfTouchesRequired : 1];
            
            [cf addGestureRecognizer:double_tap_recognizer];

            
        }else{
            cf=[calendars objectAtIndex:i];
        }
        [cf setMonth:(int)tmp_m withYear:(int)currentYear];
        
       
        [cf setFrame:CGRectMake(ira_x, ira_y+(oneElementSize/3), oneElementWidth-(border/2), oneElementSize)];
        ira_x+=oneElementWidth;
        if(ira_x>=widthOverWidth){
            ira_x=0;
            ira_y+=oneElementSize;
        }
        tmp_m++;
    }
    
    
    
    for(;i<[calendars count];i++){
        NSLog(@"remove");
        UIView* u=[calendars objectAtIndex:i];
        [u removeFromSuperview];
        [calendars removeObjectAtIndex:i];
    }
    
   
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self restructIfNeeded];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(!self){return nil;}
    calendars=[[NSMutableArray alloc]init];
    countYear = [[NSMutableArray alloc]init];
    
    [self setYearLabel:[[UILabel alloc]initWithFrame:CGRectZero]];
    [self setYear:2099];
    return self;
}

- (void) setYear:(int)year{
    currentYear=year;
    [self restructIfNeeded];
    [self setNeedsDisplay];
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(!self){return nil;}
    return [self initWithFrame:self.frame];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
