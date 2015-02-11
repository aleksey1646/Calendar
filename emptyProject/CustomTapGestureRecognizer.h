//
//  UIExtendedTapGestureRecognizer.h
//  emptyProject
//
//  Created by Ekaterina Mazalova on 2/11/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTapGestureRecognizer : UIGestureRecognizer

// Default is 1. The number of taps required to match
@property (nonatomic) NSUInteger  numberOfTapsRequired;
// Default is 1. The number of fingers required to match
@property (nonatomic) NSUInteger  numberOfTouchesRequired;

/*
 * @return count of taps on screen
 */
- (int)tapCount;

@end
