////
////  ViewSelectedMonth.m
////  emptyProject
////
////  Created by Katushka Mazalova on 21.02.15.
////  Copyright (c) 2015 A.O. All rights reserved.
////
//
//#import "ViewSelectedMonth.h"
//
//@implementation ViewSelectedMonth
//
//
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
//#pragma mark - addDaysLabels
//- (void)addDaysLabels
//{
//    
//    if (self.baseView) {
//        [self.baseView removeFromSuperview];
//    }
//    
//    UIView *baseView = [[UIView alloc]initWithFrame:CGRectZero];
//    baseView.frame= self.frame;
//    
//    self.baseView = baseView;
//    
//    baseView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:baseView];
//    
//    //int dayInThisMonth = [new_mf getDaysInThisMonth];
//    NSMutableArray *dayPositions = [self getDayPositionDictionaries];
//    
//    NSDictionary *firstDictDay = [dayPositions firstObject];
//    
//    float yFirstDay = [[firstDictDay objectForKey:@"frame_y"] floatValue];
//    float heightDay = [[firstDictDay objectForKey:@"frame_height"] floatValue];
//    float widthDay = [[firstDictDay objectForKey:@"frame_width"] floatValue];
//    
//    //NSMutableArray *dayPositionInMf= [self getDayPositionDictionaries];
//    int countVisibleDays = 0;
//    for(NSDictionary* labelDict in dayPositions){
//        
//        CGRect rect = CGRectMake([[labelDict objectForKey:@"frame_x"] floatValue],
//                                 [[labelDict objectForKey:@"frame_y"] floatValue]+[[labelDict objectForKey:@"frame_height"] floatValue]/2.5,
//                                 [[labelDict objectForKey:@"frame_width"] floatValue],
//                                 [[labelDict objectForKey:@"frame_height"] floatValue]/3);
//        
//        
//        if (![[labelDict objectForKey:@"visibility"] boolValue]) {
//            continue;
//        }
//        
//        UILabel *labelDay = [[UILabel alloc]initWithFrame:rect];
//        
//        [labelDay setText:[labelDict objectForKey:@"text"]];
//        [labelDay setFont:[UIFont systemFontOfSize:12]];
//        
//        if (labelDay.frame.origin.x>widthDay*4) {
//            
//            labelDay.textColor = [UIColor lightGrayColor];
//            
//        } else {
//            labelDay.textColor = [UIColor blackColor];
//        }
//        
//        labelDay.backgroundColor = [UIColor clearColor];//clearColor
//        [labelDay setTextAlignment:NSTextAlignmentCenter];
//        UITapGestureRecognizer *tapRecognizer;
//        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:_delegate action: @selector (clickOnMonthView:)];
//        
//        [tapRecognizer setNumberOfTouchesRequired : 1];
//        labelDay.userInteractionEnabled = YES;
//        
//        if ([[labelDict objectForKey:@"selected"]isEqualToString:@"YES"]) {
//            
//            
//            //            labelDay.layer.cornerRadius = labelDay.frame.size.width / 4.0;
//            labelDay.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:0.9];
//            labelDay.textColor = [UIColor whiteColor];
//        }
//        
//        if ([[labelDict objectForKey:@"visibility"] boolValue]) {
//            countVisibleDays++;
//        }
//        
//        [baseView addSubview:labelDay];
//        [labelDay addGestureRecognizer:tapRecognizer];
//        
//    }
//    
//    NSDictionary *lastDictDay = [dayPositions objectAtIndex:countVisibleDays-1];
//    float yLastDay = [[lastDictDay objectForKey:@"frame_y"] floatValue]+[[firstDictDay objectForKey:@"frame_height"] floatValue]/2.5;
//    
//    
//    for (int i = 0; i<6; i++) {
//        
//        UIView *viewLine = [[UIView alloc]init];
//        viewLine.frame = CGRectMake(baseView.frame.origin.x, yFirstDay+25+(heightDay*i), baseView.frame.size.width, 0.5);
//        viewLine.backgroundColor = [UIColor lightGrayColor];
//        [baseView addSubview:viewLine];
//        
//        if (viewLine.frame.origin.y>yLastDay) {
//            
//            [viewLine removeFromSuperview];
//        }
//    }
//    
//    //NSMutableArray *arrayDayWeeks = [NSMutableArray array];
//    for (int i = 0;i<7; i++) {
//        
//        
//        CGRect rectDayWeekLabel = CGRectMake(baseView.frame.origin.x+(widthDay*i), yFirstDay-10, widthDay, heightDay/2);
//        
//        UILabel *labelDayWeek = [[UILabel alloc]initWithFrame:rectDayWeekLabel];
//        NSString *stringDayWeek = [[GLang getString: [NSString stringWithFormat:@"DayNames.full.d%d",i+1] ] substringToIndex:1];
//        [labelDayWeek setText:stringDayWeek];
//        [labelDayWeek setTextAlignment:NSTextAlignmentCenter];
//        
//        if (i>4) {
//            labelDayWeek.textColor = [UIColor lightGrayColor];
//        } else {
//            labelDayWeek.textColor = [UIColor blackColor];
//        }
//        [baseView addSubview:labelDayWeek];
//        //[arrayDayWeeks addObject:stringDayWeek];
//    }
//    
//    
//    
//    
//    
//    
//    /*
//     ctrl.view.transform = CGAffineTransformMakeScale(0.01, 0.01);
//     [UIView animateWithDuration:0.1
//     animations:^{
//     [self.view addSubview:ctrl.view];
//     ctrl.view.transform=CGAffineTransformMakeScale(1, 1);
//     }
//     completion:^(BOOL finished){
//     [ctrl.view removeFromSuperview];
//     [self.navigationController pushViewController: ctrl animated:NO];
//     }];
//     
//     */
//    
//}
//- (void) setMonth:(int)month withYear:(int)year{
//    currentMonth=month;
//    currentYear=year;
//    
//    const char* monthNames[]={"ЯНВАРЬ","ФЕВРАЛЬ","МАРТ","АПРЕЛЬ","МАЙ","ИЮНЬ","ИЮЛЬ","АВГУСТ","СЕНТЯБРЬ","ОКТЯБРЬ","НОЯБРЬ","ДЕКАБРЬ"};
//    
////    
////    [monthLabel setText:
////     [
////      NSString stringWithFormat:@"%@",                   //убрать год?
////      [NSString stringWithUTF8String:monthNames[month-1]]
////      ]
////     ];
//    
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [[NSDateComponents alloc] init];
//    [components setDay:1];
//    [components setMonth: currentMonth ];
//    [components setYear: currentYear ];
//    NSDate* d=[calendar dateFromComponents:components];
//    components=[calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitMinute|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitWeekdayOrdinal|NSCalendarUnitWeekday fromDate: d];
//    NSRange days = [ calendar rangeOfUnit:NSDayCalendarUnit
//                                   inUnit:NSMonthCalendarUnit
//                                  forDate:d];
//    days_in_this_month=(int)days.length;
//    
//    if([components weekday]==1){
//        first_is_dayn=7;
//    }else if([components weekday]==7){
//        first_is_dayn=1;
//    }else{
//        first_is_dayn=(int)[components weekday]-1;
//    }
//    
//    for(NSMutableDictionary* labelDict in dayPositionDictionaries){
//        [labelDict setObject:(days_in_this_month>=[[labelDict objectForKey:@"text"] intValue])?@"YES":@"NO" forKey:@"visibility"];
//    }
//    [self setOpaque:NO];
//    [self restructOnChange];
//    [self setNeedsDisplay];
//}
//
//
//- (void)restructOnChange{
//    if(currentYear==0){return;}
//    if(currentMonth==0){return;}
//    CGFloat orignX=0;
//    CGFloat orignY=0;
//    self.clipsToBounds = NO;
//    //self.backgroundColor = [UIColor clearColor];
//    
//    
//    orignY+=(self.frame.size.height)/20;
//    CGSize cgs= [[monthLabel text] sizeWithAttributes: @{ NSFontAttributeName :  [monthLabel font] } ];
//    [monthLabel setFrame:CGRectMake(0, orignY, self.frame.size.width, cgs.height)];
//    orignY+=cgs.height;
//    orignY+=(self.frame.size.height)/20;
//    
//    
//    CGFloat orignXStep=(self.frame.size.width-orignX)/7;
//    CGFloat orignYStep=(self.frame.size.height-orignY)/6;
//    
//    int tmp_first_is_dayn=first_is_dayn; //variable for skip
//    int currentWeekDay=first_is_dayn;
//    int dict_id=0;
//    while(true){
//        if(dict_id>=days_in_this_month){break;}
//        if(tmp_first_is_dayn!=1){
//            tmp_first_is_dayn--;
//            orignX+=orignXStep;
//        }else{
//            [[dayPositionDictionaries objectAtIndex:dict_id] setObject: [NSNumber numberWithFloat:orignX]  forKey:@"frame_x"];
//            [[dayPositionDictionaries objectAtIndex:dict_id] setObject: [NSNumber numberWithFloat:orignY]  forKey:@"frame_y"];
//            
//            [[dayPositionDictionaries objectAtIndex:dict_id] setObject: [NSNumber numberWithFloat:orignXStep]  forKey:@"frame_width"];
//            [[dayPositionDictionaries objectAtIndex:dict_id] setObject: [NSNumber numberWithFloat:orignYStep]  forKey:@"frame_height"];
//            
//            if(currentWeekDay==7){
//                currentWeekDay=1;
//                orignX=0;
//                orignY+=orignYStep;
//            }else{
//                currentWeekDay++;
//                orignX+=orignXStep;
//            }
//            dict_id++;
//        }
//    }
//    
//}
//
//
//-(void)layoutSubviews{
//    [super layoutSubviews];
//    [self restructOnChange];
//    if (self.baseView) {
//        [self addDaysLabels];
//    }
//    [self setNeedsDisplay];
//}
//
//@end
