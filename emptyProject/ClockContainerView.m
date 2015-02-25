//
//  ClockViewContainer.m
//  emptyProject
//
//  Created by Katushka Mazalova on 2/24/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "ClockContainerView.h"

@implementation ClockContainerView

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = _clockView.frame;
    float size = MIN(self.frame.size.width, self.frame.size.height);
    rect.size.width = size;
    rect.size.height = size;
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    _clockView.frame = rect;
    _selectTimeIntervalView.frame = rect;
    _clockView.center = center;
    _selectTimeIntervalView.center = center;

}

- (void)setClockView:(ClockBaseView *)clockView
{
    if (_clockView.superview) {
        [_clockView removeFromSuperview];
    }
    
    _clockView = clockView;
    _clockView.frame = CGRectMake(0, 0, self.frame.size.width,
                                  self.frame.size.height);
    
    [self addSubview:clockView];
    
    if (_selectTimeIntervalView) {
        [self bringSubviewToFront:_selectTimeIntervalView];
    }
    
}

- (void)setSelectTimeIntervalView:(ClockSelectTimeIntervalBaseView *)selectTimeIntervalView
{
    if (_selectTimeIntervalView.superview) {
        [_selectTimeIntervalView removeFromSuperview];
    }
    
    _selectTimeIntervalView = selectTimeIntervalView;
    _selectTimeIntervalView.frame = CGRectMake(0, 0, self.frame.size.width,
                                  self.frame.size.height);
    
    [self addSubview:selectTimeIntervalView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
