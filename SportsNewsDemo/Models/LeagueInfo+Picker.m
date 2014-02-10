//
//  LeagueInfo+Picker.m
//  SportsNewsDemo
//
//  Created by Joe on 2/9/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

// A category that extends the LeagueInfo managed object. Provides a method for adding a new league object to Core Data from an API legue item. 

#import "LeagueInfo+Picker.h"
#import "TSNLeagueItem.h"

@implementation LeagueInfo (Picker)

+ (LeagueInfo *)leagueForLeagueItem:(TSNLeagueItem *)leagueItem inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"LeagueInfo"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", leagueItem.name];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"There was an unexpected error %@ %@", error, error.userInfo);
    }
    if (results.count == 0) {
        // add a new league
        LeagueInfo *newLeague = [NSEntityDescription insertNewObjectForEntityForName:@"LeagueInfo" inManagedObjectContext:managedObjectContext];
        [newLeague setName:leagueItem.name];
        [newLeague setShortName:leagueItem.shortName];
        [newLeague setAbbreviation:leagueItem.abbreviation];
        return newLeague;
    }
    return [results firstObject];
}

@end
