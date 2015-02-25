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

@protocol ClockProtocol <NSObject>

- (void)setHours:(int)hours minutes:(int)minutes seconds:(int)seconds;

@end

@protocol ClockSelectTimeIntervalDelegate <NSObject>

@required
- (void)clockSelectTimeIntervalSelectedFromTime:(ClockTime)fromTime toTime:(ClockTime)toTime;

@end

#endif
