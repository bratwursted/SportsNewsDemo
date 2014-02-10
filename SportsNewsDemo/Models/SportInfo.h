//
//  SportInfo.h
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SportInfo : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *teams;
@property (nonatomic, retain) NSSet *leagues;
@end

@interface SportInfo (CoreDataGeneratedAccessors)

- (void)addTeamsObject:(NSManagedObject *)value;
- (void)removeTeamsObject:(NSManagedObject *)value;
- (void)addTeams:(NSSet *)values;
- (void)removeTeams:(NSSet *)values;

- (void)addLeaguesObject:(NSManagedObject *)value;
- (void)removeLeaguesObject:(NSManagedObject *)value;
- (void)addLeagues:(NSSet *)values;
- (void)removeLeagues:(NSSet *)values;

@end
