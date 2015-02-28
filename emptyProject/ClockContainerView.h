//
//  ClockViewContainer.h
//  emptyProject
//
//  Created by Katushka Mazalova on 2/24/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockIntervalPickerBaseControl.h"
#import "ClockBaseView.h"

@interface ClockContainerView : UIView

@property (weak, readonly) ClockIntervalPickerBaseControl *intervalPikerControl;
@property (weak, readonly) ClockBaseView *clockView;

- (void)setClockView:(ClockBaseView *)clockView;
- (void)setIntervalPikerControl:(ClockIntervalPickerBaseControl *)intervalPikerControl;

@end
