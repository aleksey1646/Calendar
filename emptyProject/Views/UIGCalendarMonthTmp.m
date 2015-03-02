//
//  UIGCalendarMonthFast.m
//  emptyProject
//
//  Created by A.O. on 08.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "UIGCalendarMonthTmp.h"
#import "GLang.h"


@interface UIGCalendarMonthTmp ()

@property (weak) UIView *baseView;
//@property (weak) NSMutableArray *arrayForSelectedDaysAndSelectedMonth;

@end

@implementation UIGCalendarMonthTmp
@synthesize font,textColor,monthLabel,yearLabel;

- (int) getCurrentMonth{
    return currentMonth;
    
}
- (int) getCurrentYear{
    return currentYear;
}

- (int) getDaysInThisMonth {
    return days_in_this_month;
}

- (NSMutableArray *)getDayPositionDictionaries {
    return dayPositionDictionaries;
}

- (void)addDaysLabels:(NSMutableArray *)dayPositions
{
    self.dayPositions = dayPositions;
    if (self.baseView) {
        [self.baseView removeFromSuperview];
    }
    
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectZero];
    
    baseView.frame= self.frame;
    
    self.baseView = baseView;
    
    baseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:baseView];
    
    //int dayInThisMonth = [new_mf getDaysInThisMonth];
    //NSMutableArray *dayPositions = [self getDayPositionDictionaries];
    
    NSDictionary *firstDictDay = [dayPositions firstObject];
    
    float yFirstDay = [[firstDictDay objectForKey:@"frame_y"] floatValue];
    float heightDay = [[firstDictDay objectForKey:@"frame_height"] floatValue];
    float widthDay = [[firstDictDay objectForKey:@"frame_width"] floatValue];
    //float widthDayForS = [[firstDictDay objectForKey:@"frame_width"] floatValue];

    //NSMutableArray *dayPositionInMf= [self getDayPositionDictionaries];
    float k = 1;
    int countVisibleDays = 0;
    for(NSDictionary* labelDict in dayPositions){
        
        
        CGRect rect = CGRectMake([[labelDict objectForKey:@"frame_x"] floatValue],
                                 [[labelDict objectForKey:@"frame_y"] floatValue]+[[labelDict objectForKey:@"frame_height"] floatValue]/2.5,
                                 [[labelDict objectForKey:@"frame_width"] floatValue],
                                 [[labelDict objectForKey:@"frame_height"] floatValue]/3);
        
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            k = 1.25;
            CGRect rectNewFrame = CGRectMake(rect.origin.x+rect.size.width/4, rect.origin.y, rect.size.width/2, rect.size.height*2);
            rect = rectNewFrame;
            NSLog(@"UIDeviceOrientationIsLandscape");
            
        }
        if (![[labelDict objectForKey:@"visibility"] boolValue]) {
            continue;
        }

        UILabel *labelDay = [[UILabel alloc]initWithFrame:rect];
        
        [labelDay setText:[labelDict objectForKey:@"text"]];
        [labelDay setFont:[UIFont systemFontOfSize:12]];
        
        if (labelDay.frame.origin.x>widthDay*k*4) {
            
            labelDay.textColor = [UIColor lightGrayColor];
            
        } else {
            labelDay.textColor = [UIColor blackColor];
        }
        
        labelDay.backgroundColor = [UIColor clearColor];//clearColor
        [labelDay setTextAlignment:NSTextAlignmentCenter];
        UITapGestureRecognizer *tapRecognizer;
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:_delegate action: @selector (clickOnMonthView:)];
        
        [tapRecognizer setNumberOfTouchesRequired : 1];
        labelDay.userInteractionEnabled = YES;
        
        
        
        if ([[labelDict objectForKey:@"selected"]isEqualToString:@"YES"]) {
            
           
            
            CGPoint savePoint = labelDay.center;
            labelDay.clipsToBounds = YES;
             float newSize = labelDay.frame.size.width;
            CGRect newFrame = CGRectMake(labelDay.frame.origin.x, labelDay.frame.origin.y, newSize/2, newSize/2);
            labelDay.frame = newFrame;
            labelDay.layer.cornerRadius = newSize / 4.0;
            labelDay.center = savePoint;
            
            
                labelDay.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:0.9];
                labelDay.textColor = [UIColor whiteColor];
           
            
        }
        
       
        
        if ([[labelDict objectForKey:@"visibility"] boolValue]) {
            countVisibleDays++;
        }
        
        [baseView addSubview:labelDay];
        [labelDay addGestureRecognizer:tapRecognizer];
        
    }
    
    
    
    NSDictionary *lastDictDay = [dayPositions objectAtIndex:countVisibleDays-1];
    float yLastDay = [[lastDictDay objectForKey:@"frame_y"] floatValue]+[[firstDictDay objectForKey:@"frame_height"] floatValue]/2.5;
 
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        yFirstDay = yFirstDay-3;
       // heightDay = heightDay*2;
        
        yLastDay = [[lastDictDay objectForKey:@"frame_y"] floatValue]+([[firstDictDay objectForKey:@"frame_height"] floatValue]*2)/2.5;
        
    }
    
    for (int i = 0; i<6; i++) {
        
        UIView *viewLine = [[UIView alloc]init];
        viewLine.frame = CGRectMake(baseView.frame.origin.x, yFirstDay+25+(heightDay*i), baseView.frame.size.width, 0.5);
        viewLine.backgroundColor = [UIColor lightGrayColor];
       
        
        [baseView addSubview:viewLine];
        
        if (viewLine.frame.origin.y>=yLastDay) {
            
            [viewLine removeFromSuperview];
        }
        
    }
    
  
    for (int i = 0;i<7; i++) {
        
        
        CGRect rectDayWeekLabel = CGRectMake(baseView.frame.origin.x+(widthDay*i), yFirstDay-10, widthDay, heightDay/2);
        
        UILabel *labelDayWeek = [[UILabel alloc]initWithFrame:rectDayWeekLabel];
        NSString *stringDayWeek = [[GLang getString: [NSString stringWithFormat:@"DayNames.full.d%d",i+1] ] substringToIndex:1];
        [labelDayWeek setText:stringDayWeek];
        [labelDayWeek setTextAlignment:NSTextAlignmentCenter];
        
        if (i>4) {
            labelDayWeek.textColor = [UIColor lightGrayColor];
        } else {
            labelDayWeek.textColor = [UIColor blackColor];
        }
        [baseView addSubview:labelDayWeek];
        
    }
    
    
    
    
    
    
    /*
     ctrl.view.transform = CGAffineTransformMakeScale(0.01, 0.01);
     [UIView animateWithDuration:0.1
     animations:^{
     [self.view addSubview:ctrl.view];
     ctrl.view.transform=CGAffineTransformMakeScale(1, 1);
     }
     completion:^(BOOL finished){
     [ctrl.view removeFromSuperview];
     [self.navigationController pushViewController: ctrl animated:NO];
     }];
     
     */

}

- (void)restructOnChange{
    if(currentYear==0){return;}
    if(currentMonth==0){return;}
    CGFloat orignX=0;
    CGFloat orignY=0;
    self.clipsToBounds = NO;
    //self.backgroundColor = [UIColor clearColor];
    
    
    orignY+=(self.frame.size.height)/20;
    CGSize cgs= [[monthLabel text] sizeWithAttributes: @{ NSFontAttributeName :  [monthLabel font] } ];
    [monthLabel setFrame:CGRectMake(0, orignY, self.frame.size.width, cgs.height)];
    orignY+=cgs.height;
    orignY+=(self.frame.size.height)/20;
    
    
    CGFloat orignXStep=(self.frame.size.width-orignX)/7;
    CGFloat orignYStep=(self.frame.size.height-orignY)/6;
    
    int tmp_first_is_dayn=first_is_dayn; //variable for skip
    int currentWeekDay=first_is_dayn;
    int dict_id=0;
    while(true){
        if(dict_id>=days_in_this_month){break;}
        if(tmp_first_is_dayn!=1){
            tmp_first_is_dayn--;
            orignX+=orignXStep;
        }else{
            [[dayPositionDictionaries objectAtIndex:dict_id] setObject: [NSNumber numberWithFloat:orignX]  forKey:@"frame_x"];
            [[dayPositionDictionaries objectAtIndex:dict_id] setObject: [NSNumber numberWithFloat:orignY]  forKey:@"frame_y"];
            
            [[dayPositionDictionaries objectAtIndex:dict_id] setObject: [NSNumber numberWithFloat:orignXStep]  forKey:@"frame_width"];
            [[dayPositionDictionaries objectAtIndex:dict_id] setObject: [NSNumber numberWithFloat:orignYStep]  forKey:@"frame_height"];
            
            if(currentWeekDay==7){
                currentWeekDay=1;
                orignX=0;
                orignY+=orignYStep;
            }else{
                currentWeekDay++;
                orignX+=orignXStep;
            }
            dict_id++;
        }
    }

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self restructOnChange];
    if (self.baseView) {

        if (self.dayPositions) {
            [self addDaysLabels:self.dayPositions];
        }
        
    }
    [self setNeedsDisplay];
    
}

- (void) setMonth:(int)month withYear:(int)year{
    currentMonth=month;
    currentYear=year;
    
    const char* monthNames[]={"ЯНВАРЬ","ФЕВРАЛЬ","МАРТ","АПРЕЛЬ","МАЙ","ИЮНЬ","ИЮЛЬ","АВГУСТ","СЕНТЯБРЬ","ОКТЯБРЬ","НОЯБРЬ","ДЕКАБРЬ"};
    
    
    [monthLabel setText:
     [
      NSString stringWithFormat:@"%@",                   //убрать год?
     [NSString stringWithUTF8String:monthNames[month-1]]
     ]
     ];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    [components setMonth: currentMonth ];
    [components setYear: currentYear ];
    NSDate* d=[calendar dateFromComponents:components];
    components=[calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMinute|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitWeekdayOrdinal|NSCalendarUnitWeekday fromDate: d];
    NSRange days = [ calendar rangeOfUnit:NSDayCalendarUnit
                                   inUnit:NSMonthCalendarUnit
                                  forDate:d];
    days_in_this_month=(int)days.length;
    
    if([components weekday]==1){
        first_is_dayn=7;
    }else if([components weekday]==7){
        first_is_dayn=1;
    }else{
        first_is_dayn=(int)[components weekday]-1;
    }

    for(NSMutableDictionary* labelDict in dayPositionDictionaries){
        [labelDict setObject:(days_in_this_month>=[[labelDict objectForKey:@"text"] intValue])?@"YES":@"NO" forKey:@"visibility"];
    }
    [self setOpaque:NO];
    [self restructOnChange];
    [self setNeedsDisplay];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(!self){return nil;}
    dayPositionDictionaries=[[NSMutableArray alloc]init];
    for(int i=0;i<32;i++){
        [dayPositionDictionaries addObject: [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                             [[NSNumber alloc]initWithFloat:0.0f] ,@"frame_x",
                                             [[NSNumber alloc]initWithFloat:0.0f] ,@"frame_y",
                                             [[NSNumber alloc]initWithFloat:0.0f] ,@"frame_width",
                                             [[NSNumber alloc]initWithFloat:0.0f] ,@"frame_height",
                                             [NSString stringWithFormat:@"%d",i+1],@"text",
                                             @"NO",@"visibility",
                                             nil] ];
    }
    [self setFont:[UIFont systemFontOfSize:12]];
    [self setTextColor:[UIColor blackColor]];
    [self setMonthLabel:[[UILabel alloc]initWithFrame:CGRectZero]];
    [self addSubview:monthLabel];
    [monthLabel setTextAlignment:NSTextAlignmentLeft];
    [monthLabel setTextColor:[UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:1]];
    [self setMonth:1 withYear:2015]; //last in init
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(!self){return nil;}
    self=[self initWithFrame:CGRectZero];
    if(!self){return nil;}
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
}
- (void) selectedDays:(NSMutableArray *)dayPositionInMf {
    
    for (int i = 0; i<[dayPositionDictionaries count]; i++) {
        NSDictionary *labelDict = [dayPositionDictionaries objectAtIndex:i];
     
        NSDictionary *labelDictMf = [dayPositionInMf objectAtIndex:i];
            
            if ([[labelDictMf objectForKey:@"selected"]isEqualToString:@"YES"]) {
                
                [labelDict setValue:@"YES" forKey:@"selected"];
               
            } else {
                 [labelDict setValue:@"NO" forKey:@"selected"];
            }
            
        
     
    }
    

    [self setNeedsDisplay];
}
- (void) selectAllDaysInMonth {
    for (NSDictionary *labelDict in dayPositionDictionaries) {
        [labelDict setValue:@"YES" forKey:@"selected"];
        
    }
    [self setNeedsDisplay];
    
}
- (void) unselectAllDaysInMonth {
    for (NSDictionary *labelDict in dayPositionDictionaries) {
        [labelDict setValue:@"NO" forKey:@"selected"];
        
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    @autoreleasepool {
    [super drawRect:rect];
    NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : textColor };
   
        
    CGSize c9fontSizeResult=[@"9" sizeWithAttributes: @{NSFontAttributeName: [self font] } ];
    CGSize  c99fontSizeResult=[@"99" sizeWithAttributes: @{NSFontAttributeName: [self font] } ];
    CGFloat c9hd2=c9fontSizeResult.height/2;
    CGFloat c9wd2=c9fontSizeResult.width/2;
    CGFloat c99hd2=c99fontSizeResult.height/2;
    CGFloat c99wd2=c99fontSizeResult.width/2;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
  
    for(NSDictionary* labelDict in dayPositionDictionaries){
        if([[labelDict objectForKey:@"visibility"] isEqualToString:@"YES"]){
            NSString* wrstr=[labelDict objectForKey:@"text"];
            NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString: wrstr attributes:stringAttrs];
            
            CGFloat fx=[[labelDict objectForKey:@"frame_x"] floatValue];
            CGFloat fy=[[labelDict objectForKey:@"frame_y"] floatValue];
            CGFloat fw=[[labelDict objectForKey:@"frame_width"] floatValue];
            CGFloat fh=[[labelDict objectForKey:@"frame_height"] floatValue];
            int textInt=[wrstr intValue];
            CGFloat chd2;
            CGFloat cwd2;
            if(textInt==9){
                chd2=c9hd2;
                cwd2=c9wd2;
            }else{//99
                chd2=c99hd2;
                cwd2=c99wd2;
            }
            
            if ([[labelDict objectForKey:@"selected"] boolValue]) {
                
                 NSDictionary* stringAttrsForSelect = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor whiteColor] };
                NSAttributedString* attrStrForSelect = [[NSAttributedString alloc] initWithString: [labelDict objectForKey:@"text"] attributes:stringAttrsForSelect];
                
                CGRect borderRect = CGRectMake(fx, fy + 1.1, fw/1.1, fh/1.1);
                UIColor *color = [UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:0.9];
                CGContextSetFillColorWithColor(ctx, color.CGColor);
                CGContextFillEllipseInRect (ctx, borderRect);
                CGContextFillPath(ctx);
                
                [attrStrForSelect drawAtPoint:CGPointMake(fx+(fw/2)-cwd2,fy+(fh/2)-chd2)];
                continue;

                
            }
            
            //NSLog(@"%@",)
            
            [attrStr drawAtPoint:CGPointMake(fx+(fw/2)-cwd2,fy+(fh/2)-chd2)];
        }
    }
        
        
    }
}


@end
