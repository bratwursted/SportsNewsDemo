//
//  TSNSportsItem.h
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSNSportsItem : NSObject

+ (instancetype)sportsItemWithData:(NSDictionary *)data; 

- (NSString *)name;
- (NSString *)displayName; 
- (NSArray *)leagues; 

@end
