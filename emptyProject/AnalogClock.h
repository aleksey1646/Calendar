//
//  AnalogClock.h
//  emptyProject
//
//  Created by Katushka Mazalova on 22.02.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockBaseView.h"

@interface AnalogClock : ClockBaseView

@property (weak) UIImageView *hourArrow;
@property (weak) UIImageView *minuteArrow;
@property (weak) UIImageView *secondsArrow;

@end
