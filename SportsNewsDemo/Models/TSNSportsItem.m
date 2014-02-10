//
//  TSNSportsItem.m
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

// A class to represent a sport item as returned from the API. Associated data is stored in a NSDictionary. Provides methods to retrieve properties like the name and and array of leagues.

#import "TSNSportsItem.h"

@interface TSNSportsItem ()

@property (nonatomic, strong) NSDictionary *itemData;

@end

@implementation TSNSportsItem

+ (instancetype)sportsItemWithData:(NSDictionary *)data
{
    TSNSportsItem *sportsItem = [[self alloc] init];
    sportsItem.itemData = data; 
    return sportsItem;
}

- (NSString *)displayName
{
    NSString *sportName = [_itemData valueForKey:@"name"];
    if (sportName != nil) {
        return [sportName capitalizedString];
    }
    return @"N/A";
}

- (NSString *)name
{
    return [_itemData valueForKey:@"name"];
}

- (NSArray *)leagues
{
    return [_itemData valueForKey:@"leagues"];
}

@end
