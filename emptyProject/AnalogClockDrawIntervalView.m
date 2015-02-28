//
//  AnalogClockDrawTimeIntervalView.m
//  emptyProject
//
//  Created by Katushka Mazalova on 2/27/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "AnalogClockDrawIntervalView.h"
#import "AnalogClockUtils.h"

@interface AnalogClockDrawIntervalView()
{
    int countOfDrawedCircles;
}

@end

@implementation AnalogClockDrawIntervalView

- (void)dealloc
{
    self.firstCircleColor = nil;
    self.secondCircleColor = nil;
}

- (void)drawIntervalFromTime:(ClockTime)startTime toTime:(ClockTime)endTime
{

    /* Check, are we can drawning? */
    _startTime = startTime;
    _endTime = endTime;
    
    [self setNeedsDisplay];
}

- (void)reset
{
    countOfDrawedCircles = 0;
    _startTime = ClockTimeZero;
    _endTime = ClockTimeZero;
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
    
    
    //if time < 0h and >24h
    if (ClockTimeEqualToClockTime(_startTime, _endTime))
    {
        if (countOfDrawedCircles) {
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
            
            CGContextSetFillColorWithColor(context, _secondCircleColor.CGColor);
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
        
        return;
    }
    
    
    
    /* Draw circle for situation if time interval upper 12 hours*/
    int startTime = (_startTime.hours*60+_startTime.minutes);
    int endTime = (_endTime.hours*60+_endTime.minutes);
    
    int differenceBetweenTimes;
    if (endTime <= startTime) {
        differenceBetweenTimes = 720*2 - (startTime - endTime);
    } else
    differenceBetweenTimes = endTime - startTime;
    
    if (differenceBetweenTimes >= 720)
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
        countOfDrawedCircles = 1;
    } else
        countOfDrawedCircles = 0;
    
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
