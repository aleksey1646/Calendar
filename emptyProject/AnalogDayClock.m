//
//  AnalogDayClock.m
//  emptyProject
//
//  Created by Katushka Mazalova on 22.02.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "AnalogDayClock.h"

@implementation AnalogDayClock
@synthesize hourArrow, minuteArrow, secondsArrow;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        CGPoint center = CGPointMake(frame.size.width/2, frame.size.height/2);
        
        UIImage *hourImage = [UIImage imageNamed:@"hourArror.png"];
        UIImageView *hArror = [[UIImageView alloc] initWithImage:hourImage];
        hArror.frame = CGRectMake(0, 0, 2, 75);
        hArror.center = center;
        
        self.hourArrow = hArror;
        [self addSubview:hourArrow];
        
        UIImageView *mArror = [[UIImageView alloc] initWithImage:
                               [UIImage imageNamed:@"minuteArror.png"]];
        mArror.frame = CGRectMake(0, 0, 2, 150);
        mArror.center = center;
        self.minuteArrow= mArror;
        [self addSubview:minuteArrow];
        
        UIImageView *sArror = [[UIImageView alloc] initWithImage:
                               [UIImage imageNamed:@"secondsArror.png"]];
        sArror.frame = CGRectMake(0, 0, 2, 150);
        sArror.center = center;
        self.secondsArrow = sArror;
        [self addSubview:secondsArrow];
        
    }
    
    return self;
}




@end
