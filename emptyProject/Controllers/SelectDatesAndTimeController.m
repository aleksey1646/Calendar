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
@property (weak) UIGCalendarMonthTmp *previousSelectedMonth;
@property (strong) NSMutableArray *dayPosition;
@property (weak) UIView *senderView;
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
    CGFloat clocksize=(cw.frame.size.width>cw.frame.size.height)?cw.frame.size.height:cw.frame.size.width;
    CGFloat width95p= clocksize/100*90;
    CGFloat wleft=(cw.frame.size.width/2)-(width95p/2);
    CGRect cg_clock=CGRectMake( wleft , 0, width95p, width95p);
    [gclock setFrame: cg_clock ];
    [uitableview setFrame:cg];
}
-(void) GCalendarDelegate:(UIGCalendar*)cal onOnceTap:(UIGCalendarMonthTmp*)mf{
    
        if ([self.previousSelectedMonth isEqual:mf]) {/////
            [self.previousSelectedMonth unselectAllDaysInMonth];
            self.previousSelectedMonth = nil;
       
    } else {
        [mf selectAllDaysInMonth];
        self.previousSelectedMonth = mf;
    }
   
    

}

- (void) selectDay {
    UIView *labelDayClick = self.senderView;
     float originLabel = self.senderView.frame.origin.x;
    
    for(NSDictionary* labelDict in self.dayPosition){
        if ([[labelDict objectForKey:@"clicked"]isEqualToString:@"YES"]) {
            
            if ([[labelDict objectForKey:@"frame_x"]floatValue] == originLabel) {
                if (labelDayClick.frame.size.width >50) {
                    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(labelDayClick.frame.origin.x+17, labelDayClick.frame.origin.y-13, 45.714287, 81.8198)];
                    view.backgroundColor = [UIColor clearColor];
                    
                    labelDayClick = view;
                    
                }
                //45.714287
                
                labelDayClick.layer.cornerRadius= labelDayClick.frame.size.width/1.8976;
                
                labelDayClick.clipsToBounds=YES;
                labelDayClick.backgroundColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:0.9];
                
                [self.senderView.superview addSubview: labelDayClick];
                return;
            }
            
            
        }
       
        
    }
}
- (void) unSelectDay {
    UIView *labelDayClick = self.senderView;
    float originLabel = self.senderView.frame.origin.x;
    
    for(NSDictionary* labelDict in self.dayPosition){
    if ([[labelDict objectForKey:@"clicked"]isEqualToString:@"NO"]) {
          if ([[labelDict objectForKey:@"frame_x"]floatValue] == originLabel) {
              labelDayClick.layer.cornerRadius = 0;
              labelDayClick.clipsToBounds=NO;
              labelDayClick.backgroundColor = [UIColor clearColor];
              [self.senderView.superview addSubview: labelDayClick];
              return;
              
          }

        }
    }
}
- (void)clickOnMonthView:(UITapGestureRecognizer *)sender {
    
    self.senderView = sender.view;
    NSLog(@"clickOnMonthView");
    float originLabel = sender.view.frame.origin.x;
    
    for(NSDictionary* labelDict in self.dayPosition){
       
        
        if ([[labelDict objectForKey:@"frame_x"]floatValue] == originLabel) {
            
            if ([[labelDict objectForKey:@"clicked"]isEqualToString:@"YES"]) {
                [labelDict setValue:@"NO" forKey:@"clicked"];
                [self unSelectDay];
                return;
                
            } else {
                [labelDict setValue:@"YES" forKey:@"clicked"];
                [self selectDay];
                return;
                
            }
        }
       
    }
   
    
    
   
    

}

-(void) GCalendarDelegate:(UIGCalendar*)cal onDoubleTap:(UIGCalendarMonthTmp*)mf{
    int month=[mf getCurrentMonth];
    int year=[mf getCurrentYear];
    
    UIViewController* ctrl=[ self.storyboard instantiateViewControllerWithIdentifier:@"oneMonthInEdit" ];
    UIGCalendarMonthTmp* new_mf=(UIGCalendarMonthTmp*)ctrl.view;
    
    
    [new_mf setMonth:month withYear:year];
    
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectZero];
    baseView.frame = new_mf.frame;
    baseView.backgroundColor = [UIColor whiteColor];
    [new_mf addSubview:baseView];
    
    
    //int dayInThisMonth = [new_mf getDaysInThisMonth];
    self.dayPosition = [new_mf getDayPositionDictionaries];
     for(NSDictionary* labelDict in self.dayPosition){
         
         UILabel *labelDay = [[UILabel alloc]initWithFrame:CGRectMake([[labelDict objectForKey:@"frame_x"] floatValue], [[labelDict objectForKey:@"frame_y"] floatValue], [[labelDict objectForKey:@"frame_width"] floatValue], [[labelDict objectForKey:@"frame_height"] floatValue])];
         [labelDay setText:[labelDict objectForKey:@"text"]];
        [labelDay setFont:[UIFont systemFontOfSize:12]];
         labelDay.textColor = [UIColor blackColor];
         labelDay.backgroundColor = [UIColor clearColor];
         [labelDay setTextAlignment:NSTextAlignmentCenter];
         UITapGestureRecognizer *tapRecognizer;
         tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector (clickOnMonthView:)];
         //tapRecognizer.delaysTouchesEnded = YES;
         [tapRecognizer setNumberOfTouchesRequired : 1];
         labelDay.userInteractionEnabled = YES;
         
         [baseView addSubview:labelDay];
         [labelDay addGestureRecognizer:tapRecognizer];
     
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
    [self.navigationController pushViewController: ctrl animated:YES];
//    NSLog(@"UIGCalendarYearFast! %@",mf);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateSizes];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self updateSizes];
}

-(IBAction)onSegmentClick:(id)sender{
    [gcalendar removeFromSuperview];
    [gclock removeFromSuperview];
    [uitableview removeFromSuperview];
    switch([segmentControl selectedSegmentIndex]){
        case 0:[cw addSubview:gcalendar];break;
        case 1:[cw addSubview:gclock];break;
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
  
    
    daysFooterLabel=[[UILabel alloc]initWithFrame:CGRectZero];
    [daysFooterLabel setTextColor:[UIColor grayColor]];
    [daysFooterLabel setFont:[UIFont systemFontOfSize:13]];
    [daysFooterLabel setNumberOfLines:7];
    [daysFooterLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [daysFooterLabel setTextAlignment:NSTextAlignmentCenter];
    gcalendar=[[UIGCalendar alloc]initWithFrame:CGRectZero];
    gclock=[[ClockView alloc]initWithFrame:CGRectZero];
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
