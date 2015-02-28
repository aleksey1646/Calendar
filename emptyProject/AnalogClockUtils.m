//
//  AnalogClockUtils.m
//  emptyProject
//
//  Created by Katushka Mazalova on 2/27/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "AnalogClockUtils.h"

@implementation AnalogClockUtils

+ (float)angleForHour:(int)hour andMinutes:(float)minutes
{
    float angle = 0.5*(60*hour + minutes);
    return angle;
}

+ (ClockTime)convertAngleToTime:(float)angle
{
    int commonMinutes = angle * 2;
    int hour = commonMinutes/60;
    int minutes = commonMinutes - hour * 60;
    
    return ClockTimeMake(hour, minutes, 0);
}

@end
