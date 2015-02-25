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
#import "AnalogClockSelectTimeIntervalView.h"

#define timerUpdateInterval 1.0f


@interface ClockController ()

@property (weak) ClockContainerView *clockContainer;
@property (strong) NSTimer *timer;
@property (assign) NSTimeInterval initialTimeInterval;
// CPU ticks since the last reboot in seconds
@property (assign) NSTimeInterval initialTimeIntervalWithoutRebootSystem;

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
    
    AnalogDayClockView *dayClock = [[AnalogDayClockView alloc] init];
    AnalogClockSelectTimeIntervalView *selectTimeInterval = [[AnalogClockSelectTimeIntervalView alloc] init];
    selectTimeInterval.delegate = self;
    [_clockContainer setClockView:dayClock];
    [_clockContainer setSelectTimeIntervalView:selectTimeInterval];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timerUpdateInterval
                                                  target:self
                                                selector:@selector(timerUpdate)
                                                userInfo:nil
                                                 repeats:YES];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDate *currentDate = [NSDate date];
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval additionalSecondsForCurrentTimeZone = (NSTimeInterval)[timeZone secondsFromGMTForDate:currentDate];
    
    //Start time with current time zone
    self.initialTimeInterval = [[NSDate date] timeIntervalSince1970] + additionalSecondsForCurrentTimeZone;
    self.initialTimeIntervalWithoutRebootSystem = CACurrentMediaTime();
    
    [self timerUpdate];
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
    
    NSLog(@"%02d:%02d:%02d", hours, minutes, seconds);
    
}

#pragma mark ClockSelectTimeIntervalDelegate
- (void)clockSelectTimeIntervalSelectedFromTime:(ClockTime)fromTime toTime:(ClockTime)toTime
{
    NSLog(@"clockSelectTimeIntervalSelectedFromTime in %@", [self class]);
}



@end
