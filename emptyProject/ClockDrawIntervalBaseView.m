//
//  ClockDrawTimeIntervalView.m
//  emptyProject
//
//  Created by Katushka Mazalova on 2/27/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "ClockDrawIntervalBaseView.h"

@implementation ClockDrawIntervalBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)reset
{
    
}

- (void)drawIntervalFromTime:(ClockTime)startTime toTime:(ClockTime)endTime
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
