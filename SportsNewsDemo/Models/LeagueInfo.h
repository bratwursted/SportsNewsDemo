//
//  LeagueInfo.h
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SportInfo, TeamInfo;

@interface LeagueInfo : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * abbreviation;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) NSSet *teams;
@property (nonatomic, retain) SportInfo *sport;
@end

@interface LeagueInfo (CoreDataGeneratedAccessors)

- (void)addTeamsObject:(TeamInfo *)value;
- (void)removeTeamsObject:(TeamInfo *)value;
- (void)addTeams:(NSSet *)values;
- (void)removeTeams:(NSSet *)values;

@end
