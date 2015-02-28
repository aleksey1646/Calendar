//
//  ClockBaseView.h
//  emptyProject
//
//  Created by Katushka Mazalova on 22.02.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockProtocol.h"
#import "ClockDrawIntervalBaseView.h"

@interface ClockBaseView : UIView <ClockProtocol, ClockDrawIntervalProtocol>

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@property (weak, readonly) ClockDrawIntervalBaseView *drawIntervalView;

@end
