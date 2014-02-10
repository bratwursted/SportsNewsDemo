//
//  SportInfo+Picker.m
//  SportsNewsDemo
//
//  Created by Joe on 2/9/14.
//  Copyright (c) 2014 Thinx. All rights reserved.

// A category extending the SportInfo managed object. Provides a method for adding a new sport to Core Data from an API sport item.


#import "SportInfo+Picker.h"
#import "TSNSportsItem.h"

@implementation SportInfo (Picker)

+ (SportInfo *)sportForSportItem:(TSNSportsItem *)sportItem inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    // return the sport info object or create it
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SportInfo"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", sportItem.name];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"There was an unexpected error %@ %@", error, error.userInfo);
    }
    if (results.count == 0) {
        // create a new sport object
        SportInfo *newSport = [NSEntityDescription insertNewObjectForEntityForName:@"SportInfo" inManagedObjectContext:managedObjectContext];
        [newSport setName:sportItem.name];
        return newSport;
    }
    return [results firstObject];
}

@end
