//
//  AnalogNightClock.m
//  emptyProject
//
//  Created by Katushka Mazalova on 22.02.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "AnalogNightClockView.h"
#import "AnalogClockDrawIntervalView.h"

@implementation AnalogNightClockView

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
    self.layer.contents = (id)[UIImage imageWithContentsOfResolutionIndependentFile:BundlePath(@"night_clock_bg.png")].CGImage;
    
    AnalogClockDrawIntervalView *analogDrawInterval = [[AnalogClockDrawIntervalView alloc] init];
    analogDrawInterval.firstCircleColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    analogDrawInterval.secondCircleColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    drawIntervalView = analogDrawInterval;
    [self addSubview:drawIntervalView];
    
    
    UIImage *clockfaceImage = [UIImage imageWithContentsOfResolutionIndependentFile:BundlePath(@"night_clockface.png")];
    UIImageView *analogClockface = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 261, 266)];
    analogClockface.layer.contents = (id)clockfaceImage.CGImage;
    clockFace = analogClockface;
    [self addSubview:analogClockface];
    
    UIImage *hourImage = [UIImage imageWithContentsOfResolutionIndependentFile:BundlePath(@"night_hour_arrow.png")];
    UIImageView *hArror = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 114)];
    hArror.layer.contents = (id)hourImage.CGImage;
    hourArrow = hArror;
    [self addSubview:hourArrow];
    
    UIImage *minuteImage = [UIImage imageWithContentsOfResolutionIndependentFile:BundlePath(@"night_minute_arrow.png")];
    UIImageView *mArror = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 11, 160)];
    mArror.layer.contents = (id)minuteImage.CGImage;
    minuteArrow = mArror;
    [self addSubview:minuteArrow];
    
    UIImage *secondsImage = [UIImage imageWithContentsOfResolutionIndependentFile:BundlePath(@"day_seconds_arrow.png")];
    UIImageView *sArror = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 163)];
    sArror.layer.contents = (id)secondsImage.CGImage;
    secondsArrow = sArror;
    [self addSubview:secondsArrow];
    
    self.clockType = AnalogClockNightType;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    ((AnalogClockDrawIntervalView *)drawIntervalView).circleRadius = 115 * self.frame.size.height/etalonSize;

    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    clockFace.center = center;
    hourArrow.center = center;
    minuteArrow.center = center;
    secondsArrow.center = center;
    
}

@end
