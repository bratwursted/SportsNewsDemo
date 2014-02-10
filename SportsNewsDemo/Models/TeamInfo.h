//
//  TeamInfo.h
//  SportsNewsDemo
//
//  Created by Joe on 2/9/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LeagueInfo, SportInfo;

@interface TeamInfo : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * abbreviation;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSNumber * teamID;
@property (nonatomic, retain) LeagueInfo *league;
@property (nonatomic, retain) SportInfo *sport;

@end
