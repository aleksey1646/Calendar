//
//  AnalogDayClock.m
//  emptyProject
//
//  Created by Katushka Mazalova on 22.02.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "AnalogDayClockView.h"
#import "AnalogClockDrawIntervalView.h"

@implementation AnalogDayClockView
@synthesize hourArrow, minuteArrow, secondsArrow, drawIntervalView, clockFace;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self fillingView];
    }
    return self;
}


- (void)fillingView
{
    self.layer.contents = (id)[UIImage imageWithContentsOfResolutionIndependentFile:BundlePath(@"day_clock_bg.png")].CGImage;
    
    AnalogClockDrawIntervalView *analogDrawInterval = [[AnalogClockDrawIntervalView alloc] init];
    
    analogDrawInterval.firstCircleColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:0.2];
    analogDrawInterval.secondCircleColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:0.7];
    
    drawIntervalView = analogDrawInterval;
    [self addSubview:drawIntervalView];
    
    UIImage *clockfaceImage = [UIImage imageWithContentsOfResolutionIndependentFile:BundlePath(@"day_clockface.png")];
    UIImageView *analogClockface = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 261, 266)];
    analogClockface.layer.contents = (id)clockfaceImage.CGImage;
    clockFace = analogClockface;
    [self addSubview:analogClockface];
    
    UIImage *hourImage = [UIImage imageWithContentsOfResolutionIndependentFile:BundlePath(@"day_hour_arrow.png")];
    UIImageView *hArror = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 114)];
    hArror.layer.contents = (id)hourImage.CGImage;
    hourArrow = hArror;
    [self addSubview:hourArrow];
    
    UIImage *minuteImage = [UIImage imageWithContentsOfResolutionIndependentFile:BundlePath(@"day_minute_arrow.png")];
    UIImageView *mArror = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 11, 160)];
    mArror.layer.contents = (id)minuteImage.CGImage;
    minuteArrow = mArror;
    [self addSubview:minuteArrow];
    
    UIImage *secondsImage = [UIImage imageWithContentsOfResolutionIndependentFile:BundlePath(@"day_seconds_arrow.png")];
    UIImageView *sArror = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 163)];
    sArror.layer.contents = (id)secondsImage.CGImage;
    secondsArrow = sArror;
    [self addSubview:secondsArrow];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    ((AnalogClockDrawIntervalView *)drawIntervalView).circleRadius = 116 * self.frame.size.height/etalonSize;
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);

    clockFace.center = center;
    hourArrow.center = center;
    minuteArrow.center = center;
    secondsArrow.center = center;
    
    
    
    
   
    
    
    
}


@end
