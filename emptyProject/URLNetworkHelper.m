//
//  URLDataManager.m
//  emptyProject
//
//  Created by Katushka Mazalova on 02.03.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "URLNetworkHelper.h"


@interface URLNetworkHelper () {
    
    NSMutableData *jsonData;//data which we will return to the API request
}

@property (copy) CompletionBlock completionBlock;

@end

@implementation URLNetworkHelper 

+ (instancetype)command:(NSString *)command completionBlock:(CompletionBlock)completionBlock
{
    URLNetworkHelper *networkManager = [[URLNetworkHelper alloc] init];
    [networkManager command:command completionBlock:completionBlock];
    return networkManager;
}

- (void)command:(NSString *)command completionBlock:(CompletionBlock)completionBlock
{
    
    _completionBlock = completionBlock;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:command]];
   

    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [urlConnection start];
}


- (void)command:(NSString *)command params:(NSDictionary *)params completionBlock:(CompletionBlock)completionBlock
{
    _completionBlock = completionBlock;
    
    NSDictionary *postDict = params;
    NSString *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:nil];

    
    // Create the request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:command]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d", (int)postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                  delegate:self];
    
    [connection start];
    

}


//Error
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    _completionBlock(nil, error);
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    jsonData = [[NSMutableData alloc] init];
}
/*
  Upon receipt of a new piece of data, we add them to the already obtained
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [jsonData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    NSError *jsonParsingError = nil;

    //or
    id responce = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonParsingError];
    
    if (jsonParsingError) {
        NSLog(@"JSON ERROR: %@", [jsonParsingError localizedDescription]);
    }
    
    
    _completionBlock(responce, nil);
}


@end
