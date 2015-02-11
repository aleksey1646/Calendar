//
//  UIExtendedTapGestureRecognizer.m
//  emptyProject
//
//  Created by Ekaterina Mazalova on 2/11/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "CustomTapGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#define TIMER_INTERVAL 0.25

@interface CustomTapGestureRecognizer()
{
    int _tapCount;
    int _touchesCount;
}

@property (strong) NSTimer *timer;

@end

@implementation CustomTapGestureRecognizer

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

- (instancetype)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self) {
        _tapCount = 0;
        _touchesCount = 0;
        _numberOfTapsRequired = 1;
        _numberOfTouchesRequired = 1;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    _tapCount = (int)touch.tapCount;
    _touchesCount = (int)[touches count];
    
    if ([self.timer isValid])
    {
        [self.timer invalidate];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL
                                                  target:self
                                                selector:@selector(timerDidEnd:)
                                                userInfo:nil
                                                 repeats:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateFailed;
    [self reset];
}

- (void)reset
{
    [super reset];
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)timerDidEnd:(NSTimer *)timer
{
    
    if ((_tapCount < _numberOfTapsRequired) ||
        (_touchesCount < _numberOfTouchesRequired)) {
        self.state = UIGestureRecognizerStateFailed;
        [self reset];
        return;
    }
    
    self.state = UIGestureRecognizerStateRecognized;
    [self reset];
}


- (int)tapCount
{
    return _tapCount;
}

@end
