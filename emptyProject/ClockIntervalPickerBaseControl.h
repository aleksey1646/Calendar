//
//  ClockSelectTimeIntervalBaseView.h
//  emptyProject
//
//  Created by Katushka Mazalova on 2/24/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockProtocol.h"

@interface ClockIntervalPickerBaseControl : UIControl

@property (assign) BOOL isAM;
@property (assign) ClockTime startTime;
@property (assign) ClockTime endTime;

@property (weak) id<ClockIntervalPickerControlDelegate> delegate;

@end
