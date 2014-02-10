//
//  TSNEspnApiClient.m
//  SportsNewsDemo
//
//  Created by Joe on 2/6/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

// A singleton class to handle the network requests. This class also holds the API key. 

#import "TSNEspnApiClient.h"

@implementation TSNEspnApiClient

+ (instancetype)sharedClient
{
    static TSNEspnApiClient *_client = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSDictionary *header = [NSDictionary dictionaryWithObjectsAndKeys:@"gzip, deflate", @"Accept-Encoding", nil];
        [configuration setHTTPAdditionalHeaders:header];
        NSURL *baseURL = [NSURL URLWithString:@"http://api.espn.com/v1"];
        _client = [[TSNEspnApiClient alloc] initWithBaseURL:baseURL sessionConfiguration:configuration];
    });
    return _client;
}

- (NSString *)apiKey
{
    return @""; // add your API key here
}

@end
