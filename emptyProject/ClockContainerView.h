//
//  ClockViewContainer.h
//  emptyProject
//
//  Created by Katushka Mazalova on 2/24/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockSelectTimeIntervalBaseView.h"
#import "ClockBaseView.h"

@interface ClockContainerView : UIView

@property (weak, readonly) ClockSelectTimeIntervalBaseView *selectTimeIntervalView;
@property (weak, readonly) ClockBaseView *clockView;

- (void)setClockView:(ClockBaseView *)clockView;
- (void)setSelectTimeIntervalView:(ClockSelectTimeIntervalBaseView *)selectTimeIntervalView;

@end
