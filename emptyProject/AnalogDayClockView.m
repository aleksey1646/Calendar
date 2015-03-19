//
//  AnalogDayClock.m
//  emptyProject
//
//  Created by Katushka Mazalova on 22.02.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "AnalogDayClockView.h"
#import "AnalogClockDrawIntervalView.h"

@implementation AnalogDayClockView
@synthesize hourArrow, minuteArrow, secondsArrow, drawIntervalView, clockFace;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self fillingView];
    }
    return self;
}
//Draw gradient.

-(void)drawGradientInRect:(CGRect)rect context:(CGContextRef)context{
    
//    CGGradientRef gradient;
//    //start and end points of gradient.
//    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
//    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
//    //locations of color defined in components.
//    CGFloat locations[2] = {0.0, 1.0};
//    //color components array. In this case color is same i.e white but we are changing the alpha value.
//    CGFloat components[8] = { 0.89, 0.89, 0.89, 1,
//        0.97, 0.97, 0.97, 1};
//    //RGB color space.
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    //create gradient.
//    gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
//    CGColorSpaceRelease(colorSpace);
//    //draw gradient.
//    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
//    CGGradientRelease(gradient);
    
    
}

- (void)fillingView
{
    self.layer.contents = (id)[UIImage imageWithContentsOfResolutionIndependentFile:BundlePath(@"day_clock_bg.png")].CGImage;
    
    AnalogClockDrawIntervalView *analogDrawInterval = [[AnalogClockDrawIntervalView alloc] init];
    
    analogDrawInterval.circleRadius = 112.0f;
    
    
    
    //CGContextRef context = UIGraphicsGetCurrentContext();
    
   // [self drawGradientInRect:analogDrawInterval.frame context:UIGraphicsGetCurrentContext()];
    analogDrawInterval.firstCircleColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:0.2];
    analogDrawInterval.secondCircleColor = [UIColor colorWithRed:0.53 green:0.53 blue:0.53 alpha:0.7];
    
    
      /*
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithRed:0.894 green:0.894 blue:0.894 alpha:1].CGColor,
                       (id)[UIColor colorWithRed:0.972 green:0.972 blue:0.972 alpha:1].CGColor,
                       nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    
    UIGraphicsBeginImageContext(CGSizeMake(1, analogDrawInterval.frame.origin.y+analogDrawInterval.frame.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0,analogDrawInterval.frame.origin.y+analogDrawInterval.frame.size.height), 0);
   // analogDrawInterval.secondCircleColor = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    ///
  

    */
    drawIntervalView = analogDrawInterval;
    [self addSubview:drawIntervalView];
    
    UIImage *clockfaceImage = [UIImage imageWithContentsOfResolutionIndependentFile:BundlePath(@"day_clockface.png")];
    UIImageView *analogClockface = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 261, 266)];
    analogClockface.layer.contents = (id)clockfaceImage.CGImage;
    clockFace = analogClockface;
    [self addSubview:analogClockface];
    
    UIImage *hourImage = [UIImage imageWithContentsOfResolutionIndependentFile:BundlePath(@"day_hour_arrow.png")];
    UIImageView *hArror = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 114)];
    hArror.layer.contents = (id)hourImage.CGImage;
    hourArrow = hArror;
    [self addSubview:hourArrow];
    
    UIImage *minuteImage = [UIImage imageWithContentsOfResolutionIndependentFile:BundlePath(@"day_minute_arrow.png")];
    UIImageView *mArror = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 11, 160)];
    mArror.layer.contents = (id)minuteImage.CGImage;
    minuteArrow = mArror;
    [self addSubview:minuteArrow];
    
    UIImage *secondsImage = [UIImage imageWithContentsOfResolutionIndependentFile:BundlePath(@"day_seconds_arrow.png")];
    UIImageView *sArror = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 163)];
    sArror.layer.contents = (id)secondsImage.CGImage;
    secondsArrow = sArror;
    [self addSubview:secondsArrow];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);

    clockFace.center = center;
    hourArrow.center = center;
    minuteArrow.center = center;
    secondsArrow.center = center;
    
}


@end
