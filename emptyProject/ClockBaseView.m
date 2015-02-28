//
//  ClockBaseView.m
//  emptyProject
//
//  Created by Katushka Mazalova on 22.02.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "ClockBaseView.h"

@implementation ClockBaseView

- (void)setHours:(int)hours minutes:(int)minutes seconds:(int)seconds
{
    
}

- (void)drawIntervalFromTime:(ClockTime)startTime toTime:(ClockTime)endTime
{
    if (self.drawIntervalView)
        [self.drawIntervalView drawIntervalFromTime:startTime toTime:endTime];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.drawIntervalView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
