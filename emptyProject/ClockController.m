//
//  ClockController.m
//  emptyProject
//
//  Created by Katushka Mazalova on 2/24/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "ClockController.h"
#import "ClockContainerView.h"
#import "AnalogDayClockView.h"
#import "AnalogNightClockView.h"
#import "AnalogClockView.h"
#import "AnalogClockIntervalPickerControl.h"
#import "GLang.h"

#define timerUpdateInterval 1.0f

NSString *const ClockControllerDidChangeBackgroundColorNotification = @"DidChangeBackgroundColorNotification";
NSString *const ClockControllerBackgroundColorUserInfoKey = @"ClockControllerBackgroundColorUserInfoKey";

@interface ClockController ()

@property (weak) ClockContainerView *clockContainer;
@property (strong) NSTimer *timer;
@property (assign) NSTimeInterval initialTimeInterval;
// CPU ticks since the last reboot in seconds
@property (assign) NSTimeInterval initialTimeIntervalWithoutRebootSystem;
@property (strong) AnalogDayClockView *dayClockView;
@property (strong) AnalogNightClockView *nightClockView;

@end

@implementation ClockController


- (void)dealloc
{
    [self invalidate];
}

- (void)invalidate
{
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    
    self.timer = nil;
}

- (void)loadView
{
    self.view = [[ClockContainerView alloc] init];
    _clockContainer = (ClockContainerView *)self.view;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AnalogClockIntervalPickerControl *intervalPickerControl = [[AnalogClockIntervalPickerControl alloc] init];
    intervalPickerControl.delegate = self;
    
    [_clockContainer setIntervalPikerControl:intervalPickerControl];
    [intervalPickerControl addTarget:self action:@selector(intervalPickerControlClicked:)
                    forControlEvents:UIControlEventTouchDown];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timerUpdateInterval
                                                  target:self
                                                selector:@selector(timerUpdate)
                                                userInfo:nil
                                                 repeats:YES];
    
    UILabel *label = [[UILabel alloc] init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont fontWithName:@"HelveticaNeueCyr-Light" size:(16.0)]];
    [label setTextColor:[UIColor blackColor]];
    
    [_clockContainer setLabelTimeInterval:label];
    
    // Do any additional setup after loading the view.
    
}

- (void)intervalPickerControlClicked:(id)sender
{
    //Need to call reset
    [_clockContainer.clockView reset];

//    NSLog(@"%@ %@", NSStringFromClockTime(_clockContainer.intervalPikerControl.startTime),
//          NSStringFromClockTime(_clockContainer.intervalPikerControl.endTime));
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSTimeInterval additionalSecondsForCurrentTimeZone = [Utils currentTimeZone];
    
    //Start time with current time zone
    self.initialTimeInterval = [[NSDate date] timeIntervalSince1970] + additionalSecondsForCurrentTimeZone;
    self.initialTimeIntervalWithoutRebootSystem = CACurrentMediaTime();
    
    [self initialClock];

}

- (void)initialClock
{
    AnalogClockView *analogClock = nil;
    
    if (!_nightClockView) {
        _nightClockView = [[AnalogNightClockView alloc] init];
    }
    if (!_dayClockView) {
        _dayClockView = [[AnalogDayClockView alloc] init];
    }
    
    
    int hours = ((int)(self.initialTimeInterval/60/60))%24;
    if (hours>=12)
    {
        analogClock = _nightClockView;
        _clockContainer.intervalPikerControl.isAM = NO;
        //_clockContainer.backgroundColor = [UIColor darkGrayColor];
        _clockContainer.backgroundColor = [UIColor blackColor];
        _clockContainer.labelTimeInterval.textColor = [UIColor whiteColor];
    } else
    {
        analogClock = _dayClockView;
        _clockContainer.intervalPikerControl.isAM = YES;
        _clockContainer.backgroundColor = [UIColor whiteColor];
        _clockContainer.labelTimeInterval.textColor = [UIColor blackColor];
    }
    
    [_clockContainer setClockView:analogClock];
    
     [self timerUpdate];
    //post notification with backgroundColor in dictionaryColorView
    NSDictionary *dictionaryColorView = [NSDictionary dictionaryWithObject:_clockContainer.backgroundColor forKey:ClockControllerBackgroundColorUserInfoKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:ClockControllerDidChangeBackgroundColorNotification object:nil userInfo:dictionaryColorView];
    //
    
    
   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [_clockContainer.clockView drawIntervalFromTime:ClockTimeMake(1, 0, 0) toTime:ClockTimeMake(1, 0, 0)];

    
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

- (void)timerUpdate
{
    NSTimeInterval currentTime = _initialTimeInterval + (CACurrentMediaTime() - _initialTimeIntervalWithoutRebootSystem);
    int hours = ((int)(currentTime/60/60))%24;
    int minutes = ((int)(currentTime/60))%60;
    int seconds = ((int)currentTime)%60;
    
    [_clockContainer.clockView setHours:hours minutes:minutes seconds:seconds];

}

#pragma mark ClockSelectTimeIntervalDelegate
- (void)clockIntervalPickerControlPickFromTime:(ClockTime)fromTime toTime:(ClockTime)toTime
{
//    
//    if (![self.switchFrameTime isOn]) {
//        
//        [_clockContainer.labelTimeInterval setText:[GLang getString:@"SelectDates.clock.time_frame"]];
//        return;
//    }
    
    AnalogClockView *analogClockView = (AnalogClockView *)_clockContainer.clockView;
    
    //Changes clocks, if need
    
        if (toTime.hours >=12 &&
            analogClockView.clockType == AnalogClockDayType)
        {
            analogClockView = _nightClockView;
            [_clockContainer setClockView:analogClockView];
            _clockContainer.backgroundColor = [UIColor blackColor];
            _clockContainer.labelTimeInterval.textColor = [UIColor whiteColor];
        } else if (toTime.hours <12 &&
                   analogClockView.clockType == AnalogClockNightType)
        {
            analogClockView = _dayClockView;
            [_clockContainer setClockView:analogClockView];
            _clockContainer.backgroundColor = [UIColor whiteColor];
            _clockContainer.labelTimeInterval.textColor = [UIColor blackColor];
        }
    
     [self timerUpdate];
    
    //post notification with backgroundColor in dictionaryColorView
    NSDictionary *dictionaryColorView = [NSDictionary dictionaryWithObject:_clockContainer.backgroundColor forKey:ClockControllerBackgroundColorUserInfoKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:ClockControllerDidChangeBackgroundColorNotification object:nil userInfo:dictionaryColorView];
    
    
    
    [_clockContainer.clockView drawIntervalFromTime:fromTime toTime:toTime];
    [_clockContainer.labelTimeInterval setText:[NSString stringWithFormat:@"%@ - %@",NSStringFromClockTime(fromTime),NSStringFromClockTime(toTime)]];
    

    
}



@end
