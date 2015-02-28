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

#define timerUpdateInterval 1.0f


@interface ClockController ()

@property (weak) ClockContainerView *clockContainer;
@property (strong) NSTimer *timer;
@property (assign) NSTimeInterval initialTimeInterval;
// CPU ticks since the last reboot in seconds
@property (assign) NSTimeInterval initialTimeIntervalWithoutRebootSystem;
@property (assign) BOOL hasChanges;

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
                    forControlEvents:UIControlEventTouchUpInside];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timerUpdateInterval
                                                  target:self
                                                selector:@selector(timerUpdate)
                                                userInfo:nil
                                                 repeats:YES];
    
    // Do any additional setup after loading the view.
    
}

- (void)intervalPickerControlClicked:(id)sender
{
    //Need to call reset
    [_clockContainer.clockView reset];
    _hasChanges = YES;
    
    //Not chages, selected time is equal to zero
    if (ClockTimeEqualToClockTime(_clockContainer.intervalPikerControl.startTime, ClockTimeZero) &&
        ClockTimeEqualToClockTime(_clockContainer.intervalPikerControl.endTime, ClockTimeZero)) {
        _hasChanges = NO;
    }
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
    
    int hours = ((int)(self.initialTimeInterval/60/60))%24;
    if (hours>=12)
    {
        analogClock = [[AnalogNightClockView alloc] init];
        analogClock.clockType = AnalogClockNightType;
        _clockContainer.backgroundColor = [UIColor blackColor];
    } else
    {
        analogClock = [[AnalogDayClockView alloc] init];
        analogClock.clockType = AnalogClockDayType;
        _clockContainer.backgroundColor = [UIColor lightGrayColor];
    }
    [_clockContainer setClockView:analogClock];
    
    [self timerUpdate];
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
    
    if (_hasChanges)
    {
        UIAlertView *alertAboutChanges = [[UIAlertView alloc] initWithTitle:@"Message:"
                                                        message:@"Do you want change new time interval?"
                                                       delegate:self
                                              cancelButtonTitle:@"NO"
                                              otherButtonTitles:@"YES", nil];
        [alertAboutChanges show];
        return;
    }
    
    
    AnalogClockView *analogClockView = (AnalogClockView *)_clockContainer.clockView;
    
    //Changes clocks, if need
    
        if (toTime.hours >=12 &&
            analogClockView.clockType == AnalogClockDayType)
        {
            analogClockView = [[AnalogNightClockView alloc] init];
            analogClockView.clockType = AnalogClockNightType;
            [_clockContainer setClockView:analogClockView];
            _clockContainer.backgroundColor = [UIColor blackColor];
        } else if (toTime.hours <12 &&
                   analogClockView.clockType == AnalogClockNightType)
        {
            analogClockView = [[AnalogDayClockView alloc] init];
            analogClockView.clockType = AnalogClockDayType;
            [_clockContainer setClockView:analogClockView];
            _clockContainer.backgroundColor = [UIColor lightGrayColor];
        }
        
        [self timerUpdate];
    
    [_clockContainer.clockView drawIntervalFromTime:fromTime toTime:toTime];
    
    
//    NSLog(@"fromTime %@ toTime: %@",
//          NSStringFromClockTime(fromTime),
//          NSStringFromClockTime(toTime));
}


#pragma mark -- UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            _hasChanges = NO;
            [self initialClock];
            break;
            
        default:
            break;
    }
}


@end
