//
//  TimeView.m
//  emptyProject
//
//  Created by Katushka Mazalova on 22.02.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "TimeView.h"

@implementation TimeView

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(!self){return nil;}
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ss) userInfo:nil repeats:YES];
    [self setBackgroundColor:[UIColor blackColor]];
    return self;
}
-(void)ss{
    [self setNeedsDisplay];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(!self){return nil;}
    self=[self initWithFrame:CGRectZero];
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    
}

@end
