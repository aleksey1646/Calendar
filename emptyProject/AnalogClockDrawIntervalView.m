//
//  AnalogClockDrawTimeIntervalView.m
//  emptyProject
//
//  Created by Katushka Mazalova on 2/27/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "AnalogClockDrawIntervalView.h"
#import "AnalogClockUtils.h"


@implementation AnalogClockDrawIntervalView

- (void)dealloc
{
    self.firstCircleColor = nil;
    self.secondCircleColor = nil;
}

- (void)drawIntervalFromTime:(ClockTime)startTime toTime:(ClockTime)endTime
{
    _startTime = startTime;
    _endTime = endTime;
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code

    //We haven't a time interval to draw
    if (ClockTimeEqualToClockTime(_startTime, ClockTimeZero) &&
        ClockTimeEqualToClockTime(_endTime, ClockTimeZero)) 
    {
        return;
    }
    
    
    CGPoint center = CGPointMake(self.frame.size.width/2,
                                 self.frame.size.height/2);
    double radius = _circleRadius;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGPoint points[1] = {
        center
    };
    
    
    /* Draw circle for situation if time interval upper 12 hours*/
    int startTime = (_startTime.hours*60+_startTime.minutes);
    int endTime = (_endTime.hours*60+_endTime.minutes);
    int maxTime = MAX(startTime, endTime);
    int minTime = MIN(startTime, endTime);
    int differenceBetweenTimes = maxTime - minTime;
    
    if (differenceBetweenTimes > 720)
    {
        CGContextSetFillColorWithColor(context, _firstCircleColor.CGColor);
        CGContextAddLines(context, points, sizeof(points) / sizeof(points[0]));
        CGContextAddArc(context,
                        center.x,
                        center.y,
                        radius,
                        DEGREES_TO_RADIANS(0),
                        DEGREES_TO_RADIANS(360),
                        false);
        CGContextDrawPath(context, kCGPathEOFill);
    }
    
    /* Draw angle for time interval bellow 12 hours*/
    
    float startDegrees = 0.5*(60*(_startTime.hours%12) + _startTime.minutes); //degrees
    float endDegrees = 0.5*(60*(_endTime.hours%12) + _endTime.minutes); //degrees
    

    /* If we used first color, then we will picking second color*/
    CGContextSetFillColorWithColor(context, (differenceBetweenTimes > 720)?
                                   _secondCircleColor.CGColor:_firstCircleColor.CGColor);
    
    CGContextAddLines(context, points, sizeof(points) / sizeof(points[0]));
    CGContextAddArc(context,
                    center.x,
                    center.y,
                    radius,
                    DEGREES_TO_RADIANS(startDegrees + angleOffset),
                    DEGREES_TO_RADIANS(endDegrees + angleOffset),
                    false);
    CGContextDrawPath(context, kCGPathEOFill);
   
}


@end
