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

@interface SelectDatesAndTimeController ()

@property (weak) UIGCalendarMonthTmp *previousSelectedMonthDoubleClicked;
@property (strong) NSMutableArray *dayPosition;
@property (strong) NSMutableArray *dayPositionInMf;
@property (strong) NSMutableArray *arrayWithSelectedMonth;
@property (weak) UILabel *senderView;
@end

@implementation SelectDatesAndTimeController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize cw,segmentControl;

#pragma mark - Add the note
- (void) insertDayWeekInNote {
    
    Note *someNote = self.note;
    
    someNote.dayWeek = self.dayWeeks;
    
    
    
}

-(void)updateSizes{
    CGRect cg=CGRectMake(0, 0, cw.frame.size.width,cw.frame.size.height);
    [gcalendar setFrame: cg ];
    //clock
//    CGFloat clocksize=(cw.frame.size.width>cw.frame.size.height)?cw.frame.size.height:cw.frame.size.width;
//    CGFloat width95p= clocksize/100*90;
//    CGFloat wleft=(cw.frame.size.width/2)-(width95p/2);
//    CGRect cg_clock=CGRectMake( wleft , 0, width95p, width95p);
    //[gclock setFrame: cg_clock ];
    
    CGFloat clocksize=(cw.frame.size.width>cw.frame.size.height)?cw.frame.size.height:cw.frame.size.width;
    CGFloat width =cw.frame.size.width/100*90;
    CGFloat widthleft = (cw.frame.size.width/2)-(width/2);
    CGFloat width95p= clocksize/100*90;
    CGFloat wleft=(cw.frame.size.width/2)-(width95p/2);
   
    
    CGRect rectForCellTime = CGRectMake(0, 0, cw.frame.size.width, 45.0);
    [cellWithSwitchTime setFrame:rectForCellTime];
    cellWithSwitchTime.backgroundColor = [UIColor whiteColor];
    
    CGRect cg_clock=CGRectMake( wleft ,cellWithSwitchTime.frame.origin.y+cellWithSwitchTime.frame.size.height/2 , width95p, cw.frame.size.height);

    
    
    CGRect rectForTextLabel = CGRectMake(widthleft, 0, cellWithSwitchTime.frame.size.width/2, cellWithSwitchTime.frame.size.height);
    [textLabelTime setFrame:rectForTextLabel];
    [textLabelTime setText:[GLang getString: @"SelectDates.clock.time"]];
    [textLabelTime setTextAlignment:NSTextAlignmentLeft];
    [textLabelTime setFont:[UIFont fontWithName:@"HelveticaNeueCyr-Light" size:(24.0)]];
  
    
   
    CGRect rectForSwitch = CGRectMake(cw.frame.size.width-switchView.frame.size.width - widthleft,5, switchView.frame.size.width, switchView.frame.size.height);
    [switchView setFrame:rectForSwitch];
    [cellWithSwitchTime addSubview:switchView];
    [cellWithSwitchTime addSubview:textLabelTime];
    
    CGRect rectForLineBeforeTime = CGRectMake(0, 0, cw.frame.size.width, 0.5);
    [lineBeforeCellTime setFrame:rectForLineBeforeTime];
    lineBeforeCellTime.backgroundColor = [UIColor lightGrayColor];
    
    CGRect rectForLineUnderTime = CGRectMake(0, switchView.frame.size.height+10, cw.frame.size.width, 0.5);
    [lineUnderCellTime setFrame:rectForLineUnderTime];
    lineUnderCellTime.backgroundColor = [UIColor lightGrayColor];

    
    [gclock setFrame: cg_clock ];
    [uitableview setFrame:cg];
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
                
                if (labelDayClick.frame.size.width >50) {
                    
                    UILabel *view = [[UILabel alloc]initWithFrame:CGRectMake(labelDayClick.frame.origin.x+17, labelDayClick.frame.origin.y-13, 45.714287, 81.8198)];
                        labelDayClick.frame = view.frame;
                    
                }
 
             
//             if (labelDayClick.superview) {
//                 return;
//             }
                //45.714287
            
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
             
//                [self.senderView.superview addSubview: labelDayClick];
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
 
    [self.navigationController pushViewController: ctrl animated:YES];
//    NSLog(@"UIGCalendarYearFast! %@",mf);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.dayPosition) {
        self.dayPositionInMf = self.dayPosition;
    }

    [self.previousSelectedMonthDoubleClicked selectedDays:self.dayPositionInMf];
    [self updateSizes];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self updateSizes];
}

-(IBAction)onSegmentClick:(id)sender{
    [gcalendar removeFromSuperview];
    [gclock removeFromSuperview];
    [cellWithSwitchTime removeFromSuperview];
    [lineBeforeCellTime removeFromSuperview];
    [lineUnderCellTime removeFromSuperview];
    [uitableview removeFromSuperview];
    switch([segmentControl selectedSegmentIndex]){
        case 0:[cw addSubview:gcalendar];break;
        case 1:{
            self.view.backgroundColor = [UIColor blackColor];

            //cw.backgroundColor = [UIColor blackColor];
            [cw addSubview:gclock];
            [cw addSubview:cellWithSwitchTime];
            [cw addSubview:lineBeforeCellTime];
            [cw addSubview:lineUnderCellTime];
            
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
- (void)dealloc {
    self.dayWeeks = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dayWeeks = [[NSString alloc]init];
    self.arrayWithSelectedMonth = [NSMutableArray array];
  
    
    daysFooterLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    [daysFooterLabel setTextColor:[UIColor grayColor]];
    [daysFooterLabel setFont:[UIFont systemFontOfSize:13]];
    [daysFooterLabel setNumberOfLines:7];
    [daysFooterLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [daysFooterLabel setTextAlignment:NSTextAlignmentCenter];
    gcalendar=[[UIGCalendar alloc]initWithFrame:CGRectZero];
    gclock=[[ClockView alloc]initWithFrame:CGRectZero];
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
            
            if ([stringWithDayWeeks containsString:@"monday"]) {
                
                NSMutableDictionary *cellDictExtds = [[dictExtds objectForKey:@"cells"] objectAtIndex:0];
                [cellDictExtds setObject:([[cellDictExtds objectForKey:@"type"] isEqualToString:@"default"])?@"checkbox":@"default" forKey:@"type"];
            }
            if ([stringWithDayWeeks containsString:@"tuesday"]) {
                NSMutableDictionary *cellDictExtds = [[dictExtds objectForKey:@"cells"] objectAtIndex:1];
                [cellDictExtds setObject:([[cellDictExtds objectForKey:@"type"] isEqualToString:@"default"])?@"checkbox":@"default" forKey:@"type"];
            }
            
            if ([stringWithDayWeeks containsString:@"wednesday"]) {
                NSMutableDictionary *cellDictExtds = [[dictExtds objectForKey:@"cells"] objectAtIndex:2];
                [cellDictExtds setObject:([[cellDictExtds objectForKey:@"type"] isEqualToString:@"default"])?@"checkbox":@"default" forKey:@"type"];
            }
            if ([stringWithDayWeeks containsString:@"thursday"]) {
                NSMutableDictionary *cellDictExtds = [[dictExtds objectForKey:@"cells"] objectAtIndex:3];
                [cellDictExtds setObject:([[cellDictExtds objectForKey:@"type"] isEqualToString:@"default"])?@"checkbox":@"default" forKey:@"type"];
            }
            if ([stringWithDayWeeks containsString:@"friday"]) {
                NSMutableDictionary *cellDictExtds = [[dictExtds objectForKey:@"cells"] objectAtIndex:4];
                [cellDictExtds setObject:([[cellDictExtds objectForKey:@"type"] isEqualToString:@"default"])?@"checkbox":@"default" forKey:@"type"];
            }
            if ([stringWithDayWeeks containsString:@"saturday"]) {
                NSMutableDictionary *cellDictExtds = [[dictExtds objectForKey:@"cells"] objectAtIndex:5];
                [cellDictExtds setObject:([[cellDictExtds objectForKey:@"type"] isEqualToString:@"default"])?@"checkbox":@"default" forKey:@"type"];
            }
            if ([stringWithDayWeeks containsString:@"sunday"]) {
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
