//
//  TSNLeagueItem.m
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

// A class to represent a league item as returned from the API. Associated data is stored in an NSDictionary. Provide methods to retrieve properties like name and abbreviation. 

#import "TSNLeagueItem.h"

@interface TSNLeagueItem ()

@property (nonatomic, strong) NSDictionary *itemData;

@end

@implementation TSNLeagueItem

+ (instancetype)leagueItemWithData:(NSDictionary *)itemData
{
    TSNLeagueItem *leagueItem = [[TSNLeagueItem alloc] init];
    leagueItem.itemData = itemData;
    return leagueItem;
}

- (NSString *)name
{
    NSString *leagueName = [_itemData valueForKey:@"name"];
    if (leagueName != nil) {
        return leagueName;
    }
    return @"N/A"; 
}

- (NSString *)abbreviation
{
    return [_itemData valueForKey:@"abbreviation"];
}

- (NSString *)shortName
{
    return [_itemData valueForKey:@"shortName"];
}

@end
