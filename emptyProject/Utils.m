//
//  Utils.m
//  emptyProject
//
//  Created by Katushka Mazalova on 2/24/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSTimeInterval)currentTimeZone
{
    NSDate *currentDate = [NSDate date];
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    return (NSTimeInterval)[timeZone secondsFromGMTForDate:currentDate];
}

@end
