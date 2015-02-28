//
//  ClockProtocol.h
//  emptyProject
//
//  Created by Katushka Mazalova on 22.02.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#ifndef emptyProject_ClockProtocol_h
#define emptyProject_ClockProtocol_h

/* Time. */

struct ClockTime {
    int hours;
    int minutes;
    int seconds;
};

typedef struct ClockTime ClockTime;

static inline ClockTime
ClockTimeMake(int hours, int minutes, int seconds)
{
    ClockTime clockTime;
    clockTime.hours = hours;
    clockTime.minutes = minutes;
    clockTime.seconds = seconds;
    return clockTime;
}

const ClockTime ClockTimeZero;

static inline bool
ClockTimeEqualToClockTime(ClockTime time1, ClockTime time2)
{
    return time1.hours == time2.hours &&
           time1.minutes == time2.minutes &&
           time1.seconds == time2.seconds;
}

static inline NSString *
NSStringFromClockTime(ClockTime time)
{
    return [NSString stringWithFormat:@"%02d:%02d:%02d", time.hours, time.minutes, time.seconds];
}

@protocol ClockProtocol <NSObject>

- (void)setHours:(int)hours minutes:(int)minutes seconds:(int)seconds;

@end

@protocol ClockDrawIntervalProtocol <NSObject>

- (void)drawIntervalFromTime:(ClockTime)startTime toTime:(ClockTime)endTime;

@end


@protocol ClockIntervalPickerControlDelegate <NSObject>

@required
- (void)clockIntervalPickerControlPickFromTime:(ClockTime)fromTime toTime:(ClockTime)toTime;

@end

#endif
