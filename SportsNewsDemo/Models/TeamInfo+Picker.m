//
//  TeamInfo+Picker.m
//  SportsNewsDemo
//
//  Created by Joe on 2/9/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

// A category of TeamInfo managed object. Provides convenience methods for adding a new team to Core Data from the API and finding a team in Core Data to match a team item from the API. 

#import "TeamInfo+Picker.h"
#import "SportInfo+Picker.h"
#import "LeagueInfo+Picker.h"
#import "TSNTeamItem.h"
#import "TSNSportsItem.h"
#import "TSNLeagueItem.h"

@implementation TeamInfo (Picker)

- (void)addFavorite:(TSNTeamItem *)teamItem sport:(TSNSportsItem *)sportItem league:(TSNLeagueItem *)leagueItem
{
    // set all team info values
    [self setName:teamItem.name];
    [self setLocation:teamItem.location];
    [self setNickname:teamItem.nickname];
    [self setAbbreviation:teamItem.abbreviation];
    [self setColor:teamItem.teamColor];
    [self setTeamID:[NSNumber numberWithInteger:teamItem.teamID]];
    [self setLink:teamItem.link];
    
    // get the sport
    SportInfo *sport = [SportInfo sportForSportItem:sportItem inManagedObjectContext:self.managedObjectContext];
    [self setSport:sport];
    
    // get the league
    LeagueInfo *league = [LeagueInfo leagueForLeagueItem:leagueItem inManagedObjectContext:self.managedObjectContext];
    [self setLeague:league];
    
    if (league.sport == nil) {
        [league setSport:sport];
    }
    
    // save context
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"There was an unexpected error %@ %@", error, error.userInfo);
    }
}

+ (TeamInfo *)teamForTeamItem:(TSNTeamItem *)teamItem league:(TSNLeagueItem *)leagueItem inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TeamInfo"];
    NSPredicate *teamIdPredicate = [NSPredicate predicateWithFormat:@"teamID == ", teamItem.teamID];
    NSPredicate *leaguePredicate = [NSPredicate predicateWithFormat:@"league.name == ", leagueItem.name];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[teamIdPredicate, leaguePredicate]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"There was an unexpected error %@ %@", error, error.userInfo);
    }
    return [results firstObject];
}

@end
