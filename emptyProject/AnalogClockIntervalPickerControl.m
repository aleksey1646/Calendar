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

@interface AnalogClockIntervalPickerControl ()
{
    CGPoint pointBegin;
    // Count full circles, can be <=2 for 24 hours
    int countCircles;
    int previousEndTime;
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
    float startDegrees = [self pointPairToBearingDegrees:center secondPoint:pointBegin];
    self.startTime = [AnalogClockUtils convertAngleToTime:startDegrees];
    previousEndTime = self.startTime.hours + self.startTime.minutes;
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970] + [Utils currentTimeZone];
    int hours = ((int)(currentTime/60/60))%24;
    
    ClockTime time = self.startTime;
    
    if (hours>=12) {
        time.hours += 12;
        self.startTime = time;
    }

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //end time calculate here
    //and after call super touchesMoved
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    float endDegrees = [self pointPairToBearingDegrees:center secondPoint:touchLocation];
    
    
    self.endTime = [AnalogClockUtils convertAngleToTime:endDegrees];
    
    
    int summStartTime = self.startTime.hours + self.startTime.minutes;
    int summEndTime = self.endTime.hours + self.endTime.minutes;
    
    //Check full circles
    if ((summEndTime < previousEndTime) &&
        previousEndTime > (summStartTime - chekingIntervalMinutes) &&
        summEndTime < chekingIntervalMinutes)
    {
        countCircles ++;
    } else if ((summEndTime > previousEndTime) &&
               previousEndTime < chekingIntervalMinutes &&
               summEndTime > (summStartTime - chekingIntervalMinutes))
    {
        countCircles --;
    }
    
    
    
    
    
    
    if (self.startTime.hours >= 12) {
        ClockTime time = self.endTime;
        time.hours += 12;
        self.endTime = time;

    }
    
    
    NSLog(@"degrees %f, count circles: %i", endDegrees, countCircles);
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    pointBegin = CGPointZero;
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
