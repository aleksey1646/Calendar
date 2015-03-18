//
//  AnalogClock.h
//  emptyProject
//
//  Created by Katushka Mazalova on 22.02.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockBaseView.h"
#define etalonSize 307
#define clockfaceSize CGSizeMake(261, 266)
#define hourArrorSize CGSizeMake(8, 114)
#define minuteArrorSize CGSizeMake(11, 160)
#define secondsArrorSize CGSizeMake(8, 163)

typedef enum : NSUInteger {
    AnalogClockDayType,
    AnalogClockNightType
} AnalogClockType;

@interface AnalogClockView : ClockBaseView

@property (weak, readonly) UIImageView *clockFace;
@property (weak, readonly) UIImageView *hourArrow;
@property (weak, readonly) UIImageView *minuteArrow;
@property (weak, readonly) UIImageView *secondsArrow;
@property (weak, readonly) UIImageView *centerPoint;
@property (assign)AnalogClockType clockType;

@end
