//
//  AnalogClockSelectTimeIntervalView.m
//  emptyProject
//
//  Created by Katushka Mazalova on 2/24/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "AnalogClockIntervalPickerControl.h"
#import "AnalogClockUtils.h"
#import "Utils.h"
#define chekingIntervalMinutes 5


#define countTwentyHoursFullCircles 2

@interface AnalogClockIntervalPickerControl ()
{
    CGPoint pointBegin;
    
    float previousDegrees;
    float tempCurrentDegrees;
    float startDegrees;
    float endDegrees;
    
}

@end

@implementation AnalogClockIntervalPickerControl

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    //start time calculate here
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    pointBegin = touchLocation;
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    previousDegrees = [self pointPairToBearingDegrees:center secondPoint:pointBegin];
    startDegrees = previousDegrees;
    
    //Calculate time with current time
    ClockTime startTime = [AnalogClockUtils convertAngleToTime:startDegrees];
    NSTimeInterval additionalSecondsForCurrentTimeZone = [Utils currentTimeZone];
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970] + additionalSecondsForCurrentTimeZone;
    int hours = ((int)(currentTime/60/60))%24;
    if (hours >= 12) {
        startTime.hours += 12;
    }
    
    self.startTime = startTime;

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //end time calculate here
    //and after call super touchesMoved
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    
    float currentDegrees = [self pointPairToBearingDegrees:center secondPoint:touchLocation];
    float differenceBetweenDegrees = currentDegrees - previousDegrees;
    if (fabs(differenceBetweenDegrees) >= 300) {
        differenceBetweenDegrees = fabs(differenceBetweenDegrees) - 360;
    }
    
    
    tempCurrentDegrees += differenceBetweenDegrees;
    previousDegrees = currentDegrees;
    
    /* Calculate edges to degrees*/
    if (tempCurrentDegrees < 0) {
        endDegrees = 0;
    } else
    if (tempCurrentDegrees > 360 * countTwentyHoursFullCircles) {
        endDegrees = 360 * countTwentyHoursFullCircles;
    } else
        endDegrees = tempCurrentDegrees;
    
    ClockTime additionalTimeForCurrentEndDegrees = [AnalogClockUtils convertAngleToTime:endDegrees];
    
    ClockTime sumTimes = ClockTimeSumClockTime(self.startTime, additionalTimeForCurrentEndDegrees);
    sumTimes.hours = sumTimes.hours%24;
    self.endTime = sumTimes;
    
//    NSLog(@"start degrees %f, current degrees: %f", startDegrees, endDegrees);

    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //We don't have a changes.
    if (!endDegrees) {
        self.startTime = ClockTimeZero;
        self.endTime = ClockTimeZero;
    }
    
    pointBegin = CGPointZero;
    tempCurrentDegrees = 0;
    previousDegrees = 0;
    startDegrees = 0;
    endDegrees = 0;
    [super touchesEnded:touches withEvent:event];
}

- (CGFloat)pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint)endingPoint
{
    // get origin point to origin by subtracting end from start
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y);
    // get bearing in radians
    float bearingRadians = atan2f(originPoint.y, originPoint.x);
    // convert to degrees
    // 360 degrees in 2pi, we need have 360 degrees in pi/2 then we are adding M_PI_2 to bearingRadians
    float bearingDegrees = (bearingRadians + M_PI_2) * (180.0 / M_PI);
    // correct discontinuity
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees));
    return bearingDegrees;
}



@end
