//
//  SelectDatesAndTimeController.m
//  emptyProject
//
//  Created by A.O. on 11.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "SelectDatesAndTimeController.h"
#import "GLang.h"
#import "Note.h"
#import "ClockController.h"
#import "ClockContainerView.h"
#import "UIGCalendarYearTmp.h"


@interface SelectDatesAndTimeController () <UIAlertViewDelegate> {
    UIColor *colorBackButton;
}

@property (weak) UIGCalendarMonthTmp *previousSelectedMonthDoubleClicked;
@property (strong) NSMutableArray *dayPosition;
@property (strong) NSMutableArray *dayPositionInMf;
@property (strong) NSMutableArray *arrayWithSelectedMonth;
@property (strong) ClockController *clockController;
@property (weak) UILabel *senderView;
@property (strong)  NSMutableString *stringWithMonths;
@end

@implementation SelectDatesAndTimeController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize cw,segmentControl;

#pragma mark - Parse stringDate 
- (void) parseStringDate:(NSString *)dateString  andSearchForYearWithSelectedMonthIn:(UIGCalendar *)gcalendar {
    
    

    NSArray *datesArrayFirst = [dateString componentsSeparatedByString:@";"];
    NSMutableArray *datesArray = [NSMutableArray arrayWithArray:datesArrayFirst];
    
    NSString *lastStr = [datesArrayFirst lastObject];
    if (lastStr.length==0) {
        [datesArray removeObject:lastStr];
    }
    
    for (NSString *stringDate in datesArray) {
        
         NSArray *arraySeparate = [[NSArray alloc]initWithArray:[stringDate componentsSeparatedByString:@"."]];
        NSMutableArray *arraySeparateDate = [[NSMutableArray alloc]init];
        
        for (NSString *string in arraySeparate) {
            [arraySeparateDate addObject:string];
        }
       
        NSString *year = [arraySeparateDate lastObject];
        NSString *month = [arraySeparateDate objectAtIndex:1];
        NSString *days = [arraySeparateDate firstObject];
        
        
        for (int i = 0;i<[gcalendar.calendars count]; i++) {
            
            UIGCalendarYearTmp *calendarYear = [gcalendar.calendars objectAtIndex:i];
            
            if ([calendarYear.currentYearLabel.text isEqualToString:year]) {
                
                for (UIGCalendarMonthTmp *monthCalendar in calendarYear.calendars) {
                    
                    int monthIntValue = (int)[month integerValue];
                    
                    if (monthIntValue==[monthCalendar getCurrentMonth]) {
                        
                            NSMutableArray *arrayDayPosition = [monthCalendar getDayPositionDictionaries];
                            
                            for (int l = 0;l<arrayDayPosition.count;l++) {
                                NSDictionary *dictDay = [arrayDayPosition objectAtIndex:l];
                               
                                    if ([days isEqualToString:[dictDay objectForKey:@"text"]]) {
                                        
                                        [dictDay setValue:@"YES" forKey:@"selected"];
                                    }
                             
                            }
                            [monthCalendar selectedDays:arrayDayPosition];
                   
                    }
                }
            }
            
        }

 
    }

  
}

#pragma mark - Insert in note date

-(BOOL) navigationShouldPopOnBackButton {

    return YES; // Process 'Back' button click and Pop view controler
    
}
- (void)didMoveToParentViewController:(UIViewController *)parent
{
    
   
     if (![parent isEqual:self.parentViewController]) {
         
         if (self.arrayWithSelectedMonth) {
             
             for (UIGCalendarMonthTmp *month in self.arrayWithSelectedMonth) {
                 
                 
                 for (int i = 1;i<=[month getDaysInThisMonth]; i++) {
                   NSString *stringDate = [NSString stringWithFormat:@"%d.%d.%d;",i,[month getCurrentMonth],[month getCurrentYear]];
                     NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                     [dateFormat setDateFormat:@"d.M.yyyy;"];
                     NSDate *date = [dateFormat dateFromString:stringDate];
                     
                     NSString *stringSelectedDate = [dateFormat stringFromDate:date];
                     [_stringWithMonths appendString:stringSelectedDate];
                     
                 }
 
             }
         }
         
         if (![_stringWithMonths isEqualToString:@""]) {
             
             NSMutableString *noteDate = [[NSMutableString alloc]init];
             if (self.note.date) {
                 [noteDate appendString:self.note.date];
             }
             
             [noteDate appendString:_stringWithMonths];
             self.note.date = noteDate;
         }
         
             ClockContainerView *clockContainer = (ClockContainerView*)_clockController.view;
         if (![clockContainer.labelTimeInterval.text isEqualToString:[GLang getString:@"SelectDates.clock.time_frame"]]) {
            self.note.timeInterval = clockContainer.labelTimeInterval.text;
         }
             
         
         
         
         
    
         NSLog(@"pop view controller");
     }
        
    
    
    
    
}

#pragma mark - Add the note
- (void) insertDayWeekInNote {
    
    Note *someNote = self.note;
    
    someNote.dayWeek = self.dayWeeks;
    
    
    
}

-(void)updateSizes{
    CGRect cg=CGRectMake(0, 0, cw.frame.size.width,cw.frame.size.height);
    [gcalendar setFrame: cg ];

    
    CGFloat clocksize=(cw.frame.size.width>cw.frame.size.height)?cw.frame.size.height:cw.frame.size.width;
    CGFloat width =cw.frame.size.width/100*90;
    CGFloat widthleft = (cw.frame.size.width/2)-(width/2);
    CGFloat width95p= clocksize/100*90;
    CGFloat wleft=(cw.frame.size.width/2)-(width95p/2);
   
    
    CGRect rectForCellTime = CGRectMake(0, 0, cw.frame.size.width, 40.0);
    [cellWithSwitchTime setFrame:rectForCellTime];
   

    CGRect rectForTextLabel = CGRectMake(widthleft, 0, cellWithSwitchTime.frame.size.width/2, cellWithSwitchTime.frame.size.height);
    [textLabelTime setFrame:rectForTextLabel];
    [textLabelTime setText:[GLang getString: @"SelectDates.clock.time"]];
    [textLabelTime setTextAlignment:NSTextAlignmentLeft];
    [textLabelTime setFont:[UIFont fontWithName:@"HelveticaNeueCyr-Light" size:(24.0)]];
  
    
   
    CGRect rectForSwitch = CGRectMake(cw.frame.size.width-switchView.frame.size.width - widthleft,5, switchView.frame.size.width, switchView.frame.size.height);
    [switchView setFrame:rectForSwitch];
    
    [switchView addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    
    [cellWithSwitchTime addSubview:switchView];
    [cellWithSwitchTime addSubview:textLabelTime];
    
    CGRect rectForLineBeforeTime = CGRectMake(0, 0, cw.frame.size.width, 0.5);
    [lineBeforeCellTime setFrame:rectForLineBeforeTime];
    lineBeforeCellTime.backgroundColor = [UIColor lightGrayColor];
    
    CGRect rectForLineUnderTime = CGRectMake(0, switchView.frame.size.height+10, cw.frame.size.width, 0.5);
    [lineUnderCellTime setFrame:rectForLineUnderTime];
    lineUnderCellTime.backgroundColor = [UIColor lightGrayColor];

     CGRect cg_clock=CGRectMake( wleft ,lineUnderCellTime.frame.origin.y+lineBeforeCellTime.frame.size.height , width95p, cw.frame.size.height);
    
    [_clockController.view setFrame: cg_clock ];
    

//    _clockController.switchFrameTime = switchView;
    
    [uitableview setFrame:cg];
    
    
    ClockContainerView *clockContainer = (ClockContainerView *) _clockController.view;
    clockContainer.intervalPikerControl.enabled = switchView.isOn;

    if (!switchView.isOn) {
        [clockContainer.labelTimeInterval setText:[GLang getString:@"SelectDates.clock.time_frame"]];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backgroundColorDidChange:) name:ClockControllerDidChangeBackgroundColorNotification object:nil];
    
    
}
#pragma mark - backgroundColorDidChange
- (void) backgroundColorDidChange:(NSNotification *)notification {
    
    UIColor *color = [notification.userInfo objectForKey:ClockControllerBackgroundColorUserInfoKey];
    self.view.backgroundColor = color;
    cw.backgroundColor = color;
    cellWithSwitchTime.backgroundColor = color;
    if ([color isEqual:[UIColor blackColor]]) {
        textLabelTime.textColor = [UIColor whiteColor];
    } else {
        textLabelTime.textColor = [UIColor blackColor];
    }
        
      
    
    
    
}


- (void)changeSwitch:(UISwitch *)sender{
    
   ClockContainerView *clockContainer = (ClockContainerView *) _clockController.view;
    clockContainer.intervalPikerControl.enabled = sender.isOn;
    
    if([sender isOn]){
        [clockContainer.labelTimeInterval setText:@""];
        
        NSLog(@"Switch is ON");
    } else{
        [clockContainer.labelTimeInterval setText:[GLang getString:@"SelectDates.clock.time_frame"]];
        [clockContainer.clockView drawIntervalFromTime:ClockTimeZero toTime:ClockTimeZero];
        
        NSLog(@"Switch is OFF");
    }
}

#pragma mark - onOnceTap
-(void) GCalendarDelegate:(UIGCalendar*)cal onOnceTap:(UIGCalendarMonthTmp*)mf{
    
   
    int count = [self.arrayWithSelectedMonth count];
    
            if (count) {
                
                NSMutableArray *toDestroy = [NSMutableArray arrayWithCapacity:_arrayWithSelectedMonth.count];
                for (UIGCalendarMonthTmp *month in self.arrayWithSelectedMonth) {
                    if ([month isEqual:mf]) {
                        
                        [toDestroy addObject:month];
                        [mf unselectAllDaysInMonth];
                        continue;
                    }
                   
                }
                 [self.arrayWithSelectedMonth removeObjectsInArray:toDestroy];

                
             
    
        } else {
            [self.arrayWithSelectedMonth addObject:mf];
            [mf selectAllDaysInMonth];
            return;
        }
    if (count==self.arrayWithSelectedMonth.count) {
        [self.arrayWithSelectedMonth addObject:mf];
        [mf selectAllDaysInMonth];

    }
  
   
    

}

- (void) selectDay {
    UILabel *labelDayClick = self.senderView;
      NSString *textLabel = self.senderView.text;

    
   for(NSDictionary* labelDict in self.dayPosition){
        if ([[labelDict objectForKey:@"selected"]isEqualToString:@"YES"]) {
            
         if ([[labelDict objectForKey:@"text"]isEqualToString:textLabel]) {
                
 
            
             UIColor *color = labelDayClick.textColor;
             if ([color isEqual:[UIColor lightGrayColor]]) {
                 [labelDict setValue:@"lightGrayColor" forKey:@"textColor"];
             }
             else {
                 [labelDict setValue:@"blackColor" forKey:@"textColor"];
             }
             
             labelDayClick.clipsToBounds = YES;
             
             if (!labelDayClick.layer.cornerRadius) {
                 [self setRoundedView:labelDayClick toDiameter:labelDayClick.frame.size.width];

             }
             
            labelDayClick.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:0.9];
             labelDayClick.textColor = [UIColor whiteColor];

                return;
            }
            
            
        }
       
        
    }
    
    
    
}
-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize/2, newSize/2);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 4.0;
    roundedView.center = saveCenter;
}

- (void) unSelectDay {
    UILabel *labelDayClick = self.senderView;
    
    NSString *textLabel = self.senderView.text;

    
    for(NSDictionary* labelDict in self.dayPosition){
    if ([[labelDict objectForKey:@"selected"]isEqualToString:@"NO"]) {
        
        
        if ([[labelDict objectForKey:@"text"]isEqualToString:textLabel]) {
            
            labelDayClick.backgroundColor = [UIColor clearColor];

            if ([[labelDict objectForKey:@"textColor"]isEqualToString:@"lightGrayColor"]) {
                labelDayClick.textColor = [UIColor lightGrayColor];
            }
             
            else   if ([[labelDict objectForKey:@"textColor"]isEqualToString:@"blackColor"]) {
                labelDayClick.textColor = [UIColor blackColor];
            }
            
              return;
              
          }

        }
    }
}
- (void)clickOnMonthView:(UITapGestureRecognizer *)sender {
    
    self.senderView = (UILabel *)sender.view;
    NSLog(@"clickOnMonthView text %@",self.senderView.text);
    
    NSString *textLabel = self.senderView.text;
   
    
    for(NSDictionary* labelDict in self.dayPosition){
       
        
        if ([[labelDict objectForKey:@"text"]isEqualToString:textLabel]) {
            
            if ([[labelDict objectForKey:@"selected"]isEqualToString:@"YES"]) {
                [labelDict setValue:@"NO" forKey:@"selected"];
                [self unSelectDay];
                return;
                
            } else {
                [labelDict setValue:@"YES" forKey:@"selected"];
                [self selectDay];
                return;
                
            }
        }
   
    }
}


-(void) GCalendarDelegate:(UIGCalendar*)cal onDoubleTap:(UIGCalendarMonthTmp*)mf{
    
     self.previousSelectedMonthDoubleClicked = mf;
    
    
    
    int month=[mf getCurrentMonth];
    int year=[mf getCurrentYear];
    
    UIViewController* ctrl=[ self.storyboard instantiateViewControllerWithIdentifier:@"oneMonthInEdit" ];
    
    
    UIGCalendarMonthTmp* new_mf=(UIGCalendarMonthTmp*)ctrl.view;
    [new_mf setMonth:month withYear:year];
    new_mf.delegate = self;
    
     self.dayPosition = [new_mf getDayPositionDictionaries];
    
    [new_mf addDaysLabels:self.dayPosition];
    
 NSString *stringFormatBackButtonItem = [NSString stringWithFormat:@"%@. %d",mf.monthLabel.text.length>4?[mf.monthLabel.text substringToIndex:4]:mf.monthLabel.text,[mf getCurrentYear]];
    
     UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:[NSString stringWithString:stringFormatBackButtonItem] style:UIBarButtonItemStylePlain target:nil action:@selector(actionBackButtonClicked:)];
    
    
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController pushViewController: ctrl animated:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
   
   
    


}
- (void) actionBackButtonClicked:(UIBarButtonItem *)sender {
    
    NSLog(@"actionBackButtonClicked");
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![colorBackButton isEqual:[UIColor redColor]]) {
        [self.navigationController.navigationBar setTintColor:colorBackButton];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
   
    
    
    
    
    if (self.dayPosition) {
        self.dayPositionInMf = self.dayPosition;
        
        
        for (NSDictionary *dict in self.dayPositionInMf) {
            if ([[dict objectForKey:@"selected"]isEqualToString:@"YES"]) {
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"d.M.yyyy;"];
                 NSString *stringDate = [NSString stringWithFormat:@"%@.%d.%d;",[dict objectForKey:@"text"],[self.previousSelectedMonthDoubleClicked getCurrentMonth],[self.previousSelectedMonthDoubleClicked getCurrentYear]];
                  NSDate *date = [dateFormat dateFromString:stringDate];
                NSString *stringSelectedDate = [dateFormat stringFromDate:date];
                [_stringWithMonths appendString:stringSelectedDate];
               
                
            }
        }
  
        
    }

    
//    if (self.dayPosition) {
//        self.dayPositionInMf = self.dayPosition;
//        
//        
//        
//       
//        
//        
//        
//        
//        NSMutableString *stringSelectedDays = [[NSMutableString alloc]init];
//        
//        for (NSDictionary *dict in self.dayPositionInMf) {
//            if ([[dict objectForKey:@"selected"]isEqualToString:@"YES"]) {
//                
//                
//                [stringSelectedDays appendString:[NSString stringWithFormat:@"%@,",[dict objectForKey:@"text"]]];
//                
//            }
//        }
//      
//        if (!stringSelectedDays.length) {
//            return;
//        }
//        NSString *newString = [stringSelectedDays substringToIndex:stringSelectedDays.length-1];
//        if (newString.length!=0) {
//            [_stringWithMonths appendString:[NSString stringWithFormat:@"%@.%d.%d;",newString,[self.previousSelectedMonthDoubleClicked getCurrentMonth],[self.previousSelectedMonthDoubleClicked getCurrentYear]]];
//        }
//         
//        
//    }
    
    
    NSLog(@"viewDidAppear");
    
    [self.previousSelectedMonthDoubleClicked selectedDays:self.dayPositionInMf];
 
    
    [self updateSizes];
    
}

#pragma mark - viewDidLayoutSubviews

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self updateSizes];
    
    if (self.note.date) {
        
        
          [self parseStringDate:self.note.date andSearchForYearWithSelectedMonthIn:gcalendar];
        
        
    }
    
   
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }}



-(IBAction)onSegmentClick:(id)sender{
    [gcalendar removeFromSuperview];
    [_clockController.view removeFromSuperview];
    [cellWithSwitchTime removeFromSuperview];
    [lineBeforeCellTime removeFromSuperview];
    [lineUnderCellTime removeFromSuperview];
    cw.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [uitableview removeFromSuperview];
    switch([segmentControl selectedSegmentIndex]){
        case 0:[cw addSubview:gcalendar];break;
        case 1:{
            
            [cw addSubview:_clockController.view];
            [cw addSubview:cellWithSwitchTime];
            [cw addSubview:lineBeforeCellTime];
            [cw addSubview:lineUnderCellTime];
            NSLog(@"self.note.timeInterval %@",self.note.timeInterval);
            
            if (self.note.timeInterval) {
            
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning!" message:[NSString stringWithFormat:@"You selected the time frame \n%@\n Do you want edit?",self.note.timeInterval] delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                [alert show];
                
                
                
            }
            
            break;
        }
        case 2:[cw addSubview:uitableview];break;
    }
    
}

- (void)updateFooterText{
    NSMutableDictionary* firstSection= [extds objectAtIndex: 0 ];
    NSArray* cells=[firstSection objectForKey:@"cells"];
    NSMutableString* ms=[[NSMutableString alloc]init];
    
    for(int i=0;i<7;i++){
        NSDictionary* o=[cells objectAtIndex:i];
        bool isSelected=[[o objectForKey:@"type"] isEqualToString:@"checkbox"];
        if(isSelected){
           
            
            if(![ms isEqualToString:@""]){[ms appendString:@", "];}
            [ms appendString:[GLang getString: [NSString stringWithFormat:@"DayNames.full.d%d",i+1] ]];
        }
    }
    
    if( [ms isEqualToString:[NSString stringWithFormat:@"%@, %@, %@, %@, %@",
                             [GLang getString:@"DayNames.full.d1"],
                             [GLang getString:@"DayNames.full.d2"],
                             [GLang getString:@"DayNames.full.d3"],
                             [GLang getString:@"DayNames.full.d4"],
                             [GLang getString:@"DayNames.full.d5"]
                             ]]  ){
        [ms setString: [GLang getString:@"DayNames.full.weekday_days"] ];
    }else     if( [ms isEqualToString:[NSString stringWithFormat:@"%@, %@",
                                       [GLang getString:@"DayNames.full.d6"],
                                       [GLang getString:@"DayNames.full.d7"]
                                       ]]  ){
        [ms setString: [GLang getString:@"DayNames.full.weekend_days"] ];
    }
  
    if([ms length]){
        NSRange r={0,1};
        [daysFooterLabel setText: [NSString stringWithFormat:@"%@%@",[[ms substringWithRange:r] uppercaseString],[[ms substringFromIndex:1] lowercaseString]]  ];
    }else{
        [daysFooterLabel setText:@""];
    }

    self.dayWeeks = [daysFooterLabel text];
    [self insertDayWeekInNote];
    
//    NSMutableString * a=[firstSection objectForKey:@"footer_title"];
//    [a setString: ms ];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView!=uitableview){return nil;}
    NSMutableDictionary* firstSection= [extds objectAtIndex: [indexPath section] ];
    NSMutableDictionary* d=[[firstSection objectForKey:@"cells"] objectAtIndex:[indexPath row]];
    [d setObject:([[d objectForKey:@"type"] isEqualToString:@"default"])?@"checkbox":@"default" forKey:@"type"];
    [self updateFooterText];
    [uitableview setExtendedDataSource:extds];
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(tableView!=uitableview){return nil;}
    return daysFooterLabel;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(tableView!=uitableview){return 0;}
    return [@"A\nA\nA\nA" sizeWithAttributes:@{NSFontAttributeName: [daysFooterLabel font] }].height;
}
- (void)dealloc
{
    self.dayWeeks = nil;
    
    [self.clockController invalidate];
    self.clockController = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ClockControllerDidChangeBackgroundColorNotification object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    colorBackButton = self.navigationController.navigationBar.tintColor;

    self.dayWeeks = [[NSString alloc]init];
    self.arrayWithSelectedMonth = [NSMutableArray array];
  
    _stringWithMonths = [[NSMutableString alloc]init];
    
    daysFooterLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    [daysFooterLabel setTextColor:[UIColor grayColor]];
    [daysFooterLabel setFont:[UIFont systemFontOfSize:13]];
    [daysFooterLabel setNumberOfLines:7];
    [daysFooterLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [daysFooterLabel setTextAlignment:NSTextAlignmentCenter];
    gcalendar=[[UIGCalendar alloc]initWithFrame:CGRectZero];
//    gclock=[[ClockView alloc]initWithFrame:CGRectZero];
    
    _clockController = [[ClockController alloc] init];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backgroundColorChanges:) name:@"backgroundColorChanges" object:_clockController];
   
    
    
    textLabelTime = [[UILabel alloc]initWithFrame:CGRectZero];
    switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    cellWithSwitchTime = [[UIView alloc]initWithFrame:CGRectZero];
    lineUnderCellTime = [[UIView alloc]initWithFrame:CGRectZero];
    lineBeforeCellTime = [[UIView alloc]initWithFrame:CGRectZero];
    [gcalendar setGCalendarDelegate:self];
    
    uitableview=[[UIExtendedTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    
    extds=
    [NSArray arrayWithObjects:
     @{@"cells":
                [NSArray arrayWithObjects:
    [NSMutableDictionary dictionaryWithObjectsAndKeys:[GLang getString:@"SelectDates.day.d1"],@"title",@"UITableViewCellStyleDefault",@"style",@"",@"description",@"default",@"type", nil],
    [NSMutableDictionary dictionaryWithObjectsAndKeys:[GLang getString:@"SelectDates.day.d2"],@"title",@"UITableViewCellStyleDefault",@"style",@"",@"description",@"default",@"type", nil],
    [NSMutableDictionary dictionaryWithObjectsAndKeys:[GLang getString:@"SelectDates.day.d3"],@"title",@"UITableViewCellStyleDefault",@"style",@"",@"description",@"default",@"type", nil],
    [NSMutableDictionary dictionaryWithObjectsAndKeys:[GLang getString:@"SelectDates.day.d4"],@"title",@"UITableViewCellStyleDefault",@"style",@"",@"description",@"default",@"type", nil],
    [NSMutableDictionary dictionaryWithObjectsAndKeys:[GLang getString:@"SelectDates.day.d5"],@"title",@"UITableViewCellStyleDefault",@"style",@"",@"description",@"default",@"type", nil],
    [NSMutableDictionary dictionaryWithObjectsAndKeys:[GLang getString:@"SelectDates.day.d6"],@"title",@"UITableViewCellStyleDefault",@"style",@"",@"description",@"default",@"type", nil],
    [NSMutableDictionary dictionaryWithObjectsAndKeys:[GLang getString:@"SelectDates.day.d7"],@"title",@"UITableViewCellStyleDefault",@"style",@"",@"description",@"default",@"type", nil],
                                           nil],
       @"header_title":@"",
       @"footer_title":[[NSMutableString alloc]init],
       @"footer_align":@"center"
       }
       ,nil];
    
    if (self.note) {
        if (self.note.dayWeek) {
            
            NSString *stringWithDayWeeks = [[NSString alloc]init];
            stringWithDayWeeks = [self.note.dayWeek lowercaseString];
             NSMutableDictionary *dictExtds = [extds firstObject];
            
            if ([stringWithDayWeeks containsString:[[GLang getString:@"SelectDates.day.d1"]lowercaseString]]) {
                
                NSMutableDictionary *cellDictExtds = [[dictExtds objectForKey:@"cells"] objectAtIndex:0];
                [cellDictExtds setObject:([[cellDictExtds objectForKey:@"type"] isEqualToString:@"default"])?@"checkbox":@"default" forKey:@"type"];
            }
            if ([stringWithDayWeeks containsString:[[GLang getString:@"SelectDates.day.d2"]lowercaseString]]) {
                NSMutableDictionary *cellDictExtds = [[dictExtds objectForKey:@"cells"] objectAtIndex:1];
                [cellDictExtds setObject:([[cellDictExtds objectForKey:@"type"] isEqualToString:@"default"])?@"checkbox":@"default" forKey:@"type"];
            }
            
            if ([stringWithDayWeeks containsString:[[GLang getString:@"SelectDates.day.d3"]lowercaseString]]) {
                NSMutableDictionary *cellDictExtds = [[dictExtds objectForKey:@"cells"] objectAtIndex:2];
                [cellDictExtds setObject:([[cellDictExtds objectForKey:@"type"] isEqualToString:@"default"])?@"checkbox":@"default" forKey:@"type"];
            }
            if ([stringWithDayWeeks containsString:[[GLang getString:@"SelectDates.day.d4"]lowercaseString]]) {
                
                NSMutableDictionary *cellDictExtds = [[dictExtds objectForKey:@"cells"] objectAtIndex:3];
                [cellDictExtds setObject:([[cellDictExtds objectForKey:@"type"] isEqualToString:@"default"])?@"checkbox":@"default" forKey:@"type"];
            }
           if ([stringWithDayWeeks containsString:[[GLang getString:@"SelectDates.day.d5"]lowercaseString]]) {                NSMutableDictionary *cellDictExtds = [[dictExtds objectForKey:@"cells"] objectAtIndex:4];
                [cellDictExtds setObject:([[cellDictExtds objectForKey:@"type"] isEqualToString:@"default"])?@"checkbox":@"default" forKey:@"type"];
            }
            if ([stringWithDayWeeks containsString:[[GLang getString:@"SelectDates.day.d6"]lowercaseString]]) {
                NSMutableDictionary *cellDictExtds = [[dictExtds objectForKey:@"cells"] objectAtIndex:5];
                [cellDictExtds setObject:([[cellDictExtds objectForKey:@"type"] isEqualToString:@"default"])?@"checkbox":@"default" forKey:@"type"];
            }
            if ([stringWithDayWeeks containsString:[[GLang getString:@"SelectDates.day.d7"]lowercaseString]]) {
                NSMutableDictionary *cellDictExtds = [[dictExtds objectForKey:@"cells"] objectAtIndex:6];
                [cellDictExtds setObject:([[cellDictExtds objectForKey:@"type"] isEqualToString:@"default"])?@"checkbox":@"default" forKey:@"type"];
            }
             NSMutableString *dictFooter = [dictExtds objectForKey:@"footer_title"];
            [dictFooter appendString:stringWithDayWeeks];
            //stringWithDayWeeks;
            
            
            
        }
    }
    
    
    
    [uitableview setDelegate:self];
    
    [uitableview setExtendedDataSource:extds];
    
    [[self cw] addSubview:gcalendar];
    
    [self.segmentControl setTitle:[GLang getString:@"SelectDates.calendar"] forSegmentAtIndex:0];
    [self.segmentControl setTitle:[GLang getString:@"SelectDates.clock"] forSegmentAtIndex:1];
    [self.segmentControl setTitle:[GLang getString:@"SelectDates.days"] forSegmentAtIndex:2];
    
    [self setTitle:[GLang getString:@"SelectDates.title"]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
