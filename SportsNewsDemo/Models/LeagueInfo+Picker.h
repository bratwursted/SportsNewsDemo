//
//  LeagueInfo+Picker.h
//  SportsNewsDemo
//
//  Created by Joe on 2/9/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import "LeagueInfo.h"

@class TSNLeagueItem;

@interface LeagueInfo (Picker)

+ (LeagueInfo *)leagueForLeagueItem:(TSNLeagueItem *)leagueItem inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
