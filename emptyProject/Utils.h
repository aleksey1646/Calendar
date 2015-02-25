//
//  Utils.h
//  emptyProject
//
//  Created by Katushka Mazalova on 2/24/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <Foundation/Foundation.h>

//Math
#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

//File paths
#define BundlePath(fileWithExtension) [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileWithExtension]


@interface Utils : NSObject

@end
