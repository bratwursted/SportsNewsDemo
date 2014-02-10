//
//  TSNEspnApiClient.h
//  SportsNewsDemo
//
//  Created by Joe on 2/6/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface TSNEspnApiClient : AFHTTPSessionManager

+ (instancetype)sharedClient;
- (NSString *)apiKey; 

@end
