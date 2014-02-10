//
//  TeamInfo+Picker.h
//  SportsNewsDemo
//
//  Created by Joe on 2/9/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import "TeamInfo.h"

@class TSNSportsItem, TSNTeamItem, TSNLeagueItem;

@interface TeamInfo (Picker)

- (void)addFavorite:(TSNTeamItem *)teamItem sport:(TSNSportsItem *)sportItem league:(TSNLeagueItem *)leagueItem;
+ (TeamInfo *)teamForTeamItem:(TSNTeamItem *)teamItem league:(TSNLeagueItem *)leagueItem inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
