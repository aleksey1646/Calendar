//
//  ClockSelectTimeIntervalBaseView.h
//  emptyProject
//
//  Created by Katushka Mazalova on 2/24/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockProtocol.h"

@interface ClockSelectTimeIntervalBaseView : UIView

@property (assign) ClockTime startTime;
@property (assign) ClockTime endTime;

@property (weak) id<ClockSelectTimeIntervalDelegate> delegate;

@end
