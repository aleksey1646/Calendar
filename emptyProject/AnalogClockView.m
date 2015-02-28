//
//  AnalogClock.m
//  emptyProject
//
//  Created by Katushka Mazalova on 22.02.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "AnalogClockView.h"
#import "AnalogClockUtils.h"

@implementation AnalogClockView

- (void)setHours:(int)hours minutes:(int)minutes seconds:(int)seconds
{
    self.hourArrow.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS([AnalogClockUtils angleForHour:hours
                                                                                                    andMinutes:minutes]));
    self.minuteArrow.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS([self angleForMinute:minutes]));
    self.secondsArrow.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS([self angleForMinute:seconds]));
    
}

- (float)angleForMinute:(int)minute
{
    float angle = 6 * minute;
    return angle;
}

@end
