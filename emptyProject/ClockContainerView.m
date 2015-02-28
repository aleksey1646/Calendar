//
//  ClockViewContainer.m
//  emptyProject
//
//  Created by Katushka Mazalova on 2/24/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "ClockContainerView.h"
#import "ClockController.h"

@implementation ClockContainerView

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
  
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
//UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    
//UIViewController *clockCtrl = viewController.presentedViewController;
  //  NSLog(@"presentedViewController %@",clockCtrl);
    
//    
//    if (![clockCtrl.switchFrameTime isOn]) {
//        NSLog(@"switchFrameTime isOff!!!");
//    }
    
   
    CGRect rect = _clockView.frame;
    float size = MIN(self.frame.size.width, self.frame.size.height);
    rect.size.width = size;
    rect.size.height = size;
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-size/9.5);
    
    _clockView.frame = rect;
    _intervalPikerControl.frame = rect;
    _clockView.center = center;
    _intervalPikerControl.center = center;
    
    
    float deltaSize = self.frame.size.height-(_clockView.frame.origin.y+_clockView.frame.size.height);
    
   
    CGRect frameLabelTimeInterval = CGRectMake(0, self.frame.size.height-deltaSize,self.frame.size.width, deltaSize>40.0 ? 40.0:deltaSize);
    _labelTimeInterval.frame = frameLabelTimeInterval;
    
  
    

}
- (void) setLabelTimeInterval:(UILabel *)labelTimeInterval {
    if (_labelTimeInterval.superview) {
        [_labelTimeInterval removeFromSuperview];
    }
    _labelTimeInterval = labelTimeInterval;
    
    
    _labelTimeInterval.frame = CGRectMake(0, 0,self.frame.size.width,
                                          self.frame.size.height);
    
     [self addSubview:labelTimeInterval];
    
    
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
    
    if (_intervalPikerControl) {
        [self bringSubviewToFront:_intervalPikerControl];
    }
    
}

- (void)setIntervalPikerControl:(ClockIntervalPickerBaseControl *)intervalPikerControl
{
    if (_intervalPikerControl.superview) {
        [_intervalPikerControl removeFromSuperview];
    }
    
    _intervalPikerControl = intervalPikerControl;
    _intervalPikerControl.frame = CGRectMake(0, 0, self.frame.size.width,
                                  self.frame.size.height);
    
    [self addSubview:intervalPikerControl];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
