//
//  UIImage+Extensions.m
//  emptyProject
//
//  Created by Katushka Mazalova on 2/23/15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "UIImage+Extensions.h"

@implementation UIImage (UIImage_Extensions)

- (instancetype)initWithContentsOfResolutionIndependentFile:(NSString *)path
{
    if ( [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0 )
    {
        NSString *path2x = [[path stringByDeletingLastPathComponent]
                            stringByAppendingPathComponent:[NSString stringWithFormat:@"%@@2x.%@",
                                                            [[path lastPathComponent] stringByDeletingPathExtension],
                                                            [path pathExtension]]];
        
        if ( [[NSFileManager defaultManager] fileExistsAtPath:path2x] ) {
            return [self initWithCGImage:[[UIImage imageWithData:[NSData dataWithContentsOfFile:path2x]] CGImage] scale:2.0 orientation:UIImageOrientationUp];
        }
    }
    
    return [self initWithData:[NSData dataWithContentsOfFile:path]];
}

+ (UIImage*)imageWithContentsOfResolutionIndependentFile:(NSString *)path
{
    return [[UIImage alloc] initWithContentsOfResolutionIndependentFile:path];
}

@end
