//
//  TSNLeagueItem.h
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSNLeagueItem : NSObject

+ (instancetype)leagueItemWithData:(NSDictionary *)itemData;

- (NSString *)name;
- (NSString *)abbreviation;
- (NSString *)shortName;


@end
