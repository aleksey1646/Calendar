//
//  UIImage+Extensions.h
//  emptyProject
//
//  Created by Katushka Mazalova on 2/23/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImage_Extensions)

- (instancetype)initWithContentsOfResolutionIndependentFile:(NSString *)path;
+ (UIImage*)imageWithContentsOfResolutionIndependentFile:(NSString *)path;

@end
