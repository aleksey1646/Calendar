//
//  AnalogClock.h
//  emptyProject
//
//  Created by Katushka Mazalova on 22.02.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockBaseView.h"

@interface AnalogClockView : ClockBaseView

@property (weak, readonly) UIImageView *hourArrow;
@property (weak, readonly) UIImageView *minuteArrow;
@property (weak, readonly) UIImageView *secondsArrow;
@property (weak, readonly) UIImageView *centerPoint;

@end
