//
//  SportInfo+Picker.h
//  SportsNewsDemo
//
//  Created by Joe on 2/9/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import "SportInfo.h"

@class TSNSportsItem;

@interface SportInfo (Picker)

+ (SportInfo *)sportForSportItem:(TSNSportsItem *)sportItem inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext; 

@end
