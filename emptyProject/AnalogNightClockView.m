//
//  AnalogNightClock.m
//  emptyProject
//
//  Created by Katushka Mazalova on 22.02.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "AnalogNightClockView.h"

@implementation AnalogNightClockView

@synthesize hourArrow, minuteArrow, secondsArrow, centerPoint;

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
    
    UIImage *hourImage = [UIImage imageWithContentsOfResolutionIndependentFile:BundlePath(@"night_hour_arrow.png")];
    UIImageView *hArror = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 109)];
    hArror.layer.contents = (id)hourImage.CGImage;
    hourArrow = hArror;
    [self addSubview:hourArrow];
    
    UIImage *minuteImage = [UIImage imageWithContentsOfResolutionIndependentFile:BundlePath(@"night_minute_arrow.png")];
    UIImageView *mArror = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 168)];
    mArror.layer.contents = (id)minuteImage.CGImage;
    minuteArrow = mArror;
    [self addSubview:minuteArrow];
    
    UIImage *secondsImage = [UIImage imageWithContentsOfResolutionIndependentFile:BundlePath(@"day_seconds_arrow.png")];
    UIImageView *sArror = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 149)];
    sArror.layer.contents = (id)secondsImage.CGImage;
    secondsArrow = sArror;
    [self addSubview:secondsArrow];
    
    UIImage *centerPointImage = [UIImage imageWithContentsOfResolutionIndependentFile:BundlePath(@"day_center_point.png")];
    UIImageView *cPoint = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 4, 5)];
    cPoint.layer.contents = (id)centerPointImage.CGImage;
    centerPoint = cPoint;
    [self addSubview:cPoint];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    hourArrow.center = center;
    minuteArrow.center = center;
    secondsArrow.center = center;
    centerPoint.center = CGPointMake(center.x, center.y + 1);
    
}

@end
