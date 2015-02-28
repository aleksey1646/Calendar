//
//  AnalogClockUtils.h
//  emptyProject
//
//  Created by Katushka Mazalova on 2/27/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClockProtocol.h"

#define angleOffset -90.0f

@interface AnalogClockUtils : NSProxy

/* Calculate angle for hour and minutes */
+ (float)angleForHour:(int)hour andMinutes:(float)minutes;

+ (ClockTime)convertAngleToTime:(float)angle;

@end
