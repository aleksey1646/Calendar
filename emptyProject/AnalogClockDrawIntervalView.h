//
//  AnalogClockDrawTimeIntervalView.h
//  emptyProject
//
//  Created by Katushka Mazalova on 2/27/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "ClockDrawIntervalBaseView.h"
#import "ClockProtocol.h"

@interface AnalogClockDrawIntervalView : ClockDrawIntervalBaseView

/* Radius for drawing circle. Default a zero */
@property (assign) float circleRadius;

/* Time to draw*/
@property (assign) ClockTime startTime;
@property (assign) ClockTime endTime;

/* Color for drawing cirle before 12 hours in twenty-four hours */
@property (strong) UIColor *firstCircleColor;
/* Color for drawing cirle after 12 hours in twenty-four hours */
@property (strong) UIColor *secondCircleColor;

@end
