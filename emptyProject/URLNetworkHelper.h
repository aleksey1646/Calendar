//
//  URLDataManager.h
//  emptyProject
//
//  Created by Katushka Mazalova on 02.03.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionBlock)(id responce, NSError *error);

@interface URLNetworkHelper : NSObject <NSURLConnectionDelegate>//NSURLConnectionDataDelegate


+ (instancetype)command:(NSString *)command completionBlock:(CompletionBlock)completionBlock;
- (void)command:(NSString *)command completionBlock:(CompletionBlock)completionBlock;
- (void)command:(NSString *)command params:(NSDictionary *)params completionBlock:(CompletionBlock)completionBlock;

@property (strong,nonatomic) NSMutableArray *arrayJsonCategory;
@end
