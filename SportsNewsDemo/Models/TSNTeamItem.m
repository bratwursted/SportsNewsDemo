//
//  TSNTeamItem.m
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

// A class to represent a team item as reurned from the API. stores associated data in an NSDictionary. Provides methods to retrieve peoperties like name, location, and ID. 

#import "TSNTeamItem.h"

@interface TSNTeamItem ()

@property (nonatomic, strong) NSDictionary *itemData;

@end

@implementation TSNTeamItem

+ (instancetype)teamItemWithData:(NSDictionary *)itemData
{
    TSNTeamItem *teamItem = [[TSNTeamItem alloc] init];
    teamItem.itemData = itemData;
    return teamItem;
}

- (NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", [self location], [self name]];
}

- (NSInteger)teamID
{
    return [[_itemData valueForKey:@"id"] integerValue];
}

- (NSString *)name
{
    return [_itemData valueForKey:@"name"];
}

- (NSString *)location
{
    return [_itemData valueForKey:@"location"];
}

- (NSString *)nickname
{
    return [_itemData valueForKey:@"nickname"];
}

- (NSString *)teamColor
{
    return [_itemData valueForKey:@"color"];
}

- (NSString *)link
{
    return [[[[_itemData valueForKey:@"links"] valueForKey:@"mobile"] valueForKey:@"teams"] valueForKey:@"href"];
}

- (NSString *)abbreviation
{
    return [_itemData valueForKey:@"abbreviation"];
}

@end
