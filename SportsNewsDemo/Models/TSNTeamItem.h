//
//  TSNTeamItem.h
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSNTeamItem : NSObject

+ (instancetype)teamItemWithData:(NSDictionary *)itemData;

- (NSString *)fullName;
- (NSString *)name; 
- (NSInteger)teamID;
- (NSString *)abbreviation;
- (NSString *)teamColor;
- (NSString *)link;
- (NSString *)location;
- (NSString *)nickname;

@end
