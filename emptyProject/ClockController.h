//
//  ClockController.h
//  emptyProject
//
//  Created by Katushka Mazalova on 2/24/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockProtocol.h"
//#import "ClockContainerView.h"

extern NSString *const ClockControllerDidChangeBackgroundColorNotification;
extern NSString *const ClockControllerBackgroundColorUserInfoKey;

@interface ClockController : UIViewController <ClockIntervalPickerControlDelegate, UIAlertViewDelegate>



//@property (weak) UISwitch *switchFrameTime;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

//Do not forget call it in dealloc of owner controller, timer it's dangerous thing!
- (void)invalidate;

@end
