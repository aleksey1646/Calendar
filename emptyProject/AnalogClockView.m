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
    [super setHours:hours minutes:minutes seconds:seconds];
    
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

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    float ratio = self.frame.size.height/etalonSize;
    self.clockFace.transform = CGAffineTransformIdentity;
    CGRect faceRect = self.clockFace.frame;
    CGSize faceSize = clockfaceSize;
    faceRect.size.height = faceSize.height * ratio;
    faceRect.size.width = faceSize.width * ratio;
    self.clockFace.frame = faceRect;
    
    self.hourArrow.transform = CGAffineTransformIdentity;
    CGRect hourRect = self.hourArrow.frame;
    CGSize hourSize = hourArrorSize;
    hourRect.size.height = hourSize.height * ratio;
    hourRect.size.width = hourSize.width * ratio;
    self.hourArrow.frame= hourRect;
    
    self.minuteArrow.transform = CGAffineTransformIdentity;
    CGRect minuteRect = self.minuteArrow.frame;
    CGSize minuteSize = minuteArrorSize;
    minuteRect.size.height = minuteSize.height * ratio;
    minuteRect.size.width = minuteSize.width * ratio;
    self.minuteArrow.frame = minuteRect;

    self.secondsArrow.transform = CGAffineTransformIdentity;
    CGRect secondsRect = self.secondsArrow.frame;
    CGSize secondsSize = secondsArrorSize;
    secondsRect.size.height = secondsSize.height * ratio;
    secondsRect.size.width = secondsSize.width * ratio;
    self.secondsArrow.frame = secondsRect;
    
    [self setHours:self.time.hours minutes:self.time.minutes seconds:self.time.seconds];
//    NSLog(@"hour %@ \nmin%@ \nsec%@", self.hourArrow, self.minuteArrow, self.secondsArrow);

}


@end
