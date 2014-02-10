//
//  TSNDataItemProvider.h
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataProviderDelegate <NSObject>

- (void)shouldRefreshView;

@end

@interface TSNDataItemProvider : NSObject

@property (nonatomic, weak) id<DataProviderDelegate> delegate;

- (NSInteger)itemCount;
- (id)itemAtIndex:(NSInteger)index;

- (void)fetchSportsItems;
- (void)fetchTeamItemsForSport:(NSString *)sportName andLeague:(NSString *)leagueAbbreviation; 

// for testing
- (id)initWithItems:(NSArray *)items;

@end
