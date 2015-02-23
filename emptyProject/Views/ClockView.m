//
//  TemporaryView.m
//  emptyProject
//
//  Created by A.O. on 09.01.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "ClockView.h"
#import "AnalogDayClock.h"

@interface ClockView ()

@property (weak) AnalogDayClock *dayClock;

@end

@implementation ClockView



-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (!self.dayClock) {
        AnalogDayClock *dayClock = [[AnalogDayClock alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.dayClock = dayClock;
        [dayClock setHours:6 minutes:1 seconds:45];
        
        [self addSubview:dayClock];
    }
    
}

-(CGFloat)getSZ{
    CGFloat a= (self.frame.size.width>self.frame.size.height)?self.frame.size.height:self.frame.size.width;
    return a;
}

-(CGFloat)getCenterX{
    return [self getSZ]/2;
}


-(CGFloat)getMarginTop{
    return 0;
}

-(CGFloat)getCenterY{
    return ([self getSZ]/2)+[self getMarginTop];
    
}

int secs=1;

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat center_x=[self getCenterX];
    CGFloat center_y=[self getCenterY];
    CGFloat sz=[self getSZ];
    
    CGFloat oneHourInRadians=(M_PI)/36;
    CGContextSetRGBStrokeColor(ctx, 0.2, 0.2, 0.2, 1);
    
    CGFloat fontSize=12;
    NSDictionary* attr=@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:[UIColor whiteColor]};
    //iriski and numbers
    for(int i=0;i<72;i++){
        CGContextBeginPath(ctx);
        
        CGFloat sin_for_timefrom=sin(oneHourInRadians*((72-i)+0.0));
        CGFloat cos_for_timefrom=cos(oneHourInRadians*((72-i)+0.0));
        
        CGContextBeginPath(ctx);
        CGFloat linesizeto=sz/2;
        CGFloat linesizefrom;
        if(i%6==0){
            linesizefrom=(sz/2)-(sz/25);
            int hrs=i/6;
            NSString* str=[NSString stringWithFormat:@"%d",hrs?hrs:12];
            CGSize fontPixels=[str sizeWithAttributes: attr ];
            CGFloat str_x=center_x-(sin_for_timefrom*(linesizefrom-fontPixels.height));
            CGFloat str_y=center_y-(cos_for_timefrom*(linesizefrom-fontPixels.height));
            [str drawAtPoint:CGPointMake( str_x-(fontPixels.width/2),str_y-(fontPixels.height/2)  ) withAttributes:attr];
        }else if((i%3)==0){
            linesizefrom=(sz/2)-(sz/35);
        }else {
            linesizefrom=(sz/2)-(sz/50);
        }
        
        
        CGContextMoveToPoint   (ctx, center_x-(sin_for_timefrom*(linesizefrom)),center_y-(cos_for_timefrom*(linesizefrom))  );  // top left
        CGContextAddLineToPoint(ctx, center_x-(sin_for_timefrom*(linesizeto)),center_y-(cos_for_timefrom*(linesizeto)) );
        CGContextStrokePath(ctx);
    }
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(!self){return nil;}
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ss) userInfo:nil repeats:YES];
    [self setBackgroundColor:[UIColor blackColor]];
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(!self){return nil;}
    self=[self initWithFrame:CGRectZero];
    return self;
}

-(void)ss{
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* t=[[touches allObjects]objectAtIndex:0] ;
    CGPoint p=[t locationInView:self];
    
    CGFloat center_x=[self getCenterX];
    CGFloat center_y=[self getCenterY];
    center_y+=[self getMarginTop];
    
        NSLog(@"x=%f %f",p.x,p.y);
    
    CGFloat touch_x=p.x-center_x;
    CGFloat touch_y=p.y-center_y;
    
    CGFloat zero_gradus_x=0;
    CGFloat zero_gradus_y=abs(touch_y);
    
    CGFloat cos_one=
    ((zero_gradus_x*touch_x)+(zero_gradus_y*touch_y)) /
    (sqrt(  pow(zero_gradus_x,2)+pow(zero_gradus_y,2) ) * sqrt(  pow(touch_x,2)+pow(touch_y,2) ));
    
    CGFloat res;
    
    if(touch_x<0){
        res=180+(((acos(cos_one)* (180.0f / M_PI))));
    }else{
        res=180-(acos(cos_one)* (180.0f / M_PI));
    }
    
    secs=res/(360/72);
    
    NSLog(@"secs = %d",secs);
    
    [self setNeedsDisplay];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesMoved:touches withEvent:event];
    UITouch* t=[[touches allObjects]objectAtIndex:0] ;
    CGPoint p=[t locationInView:self];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* t=[[touches allObjects]objectAtIndex:0] ;
    CGPoint p=[t locationInView:self];
}

@end
