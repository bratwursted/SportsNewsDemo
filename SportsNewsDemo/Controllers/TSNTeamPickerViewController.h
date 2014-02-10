//
//  TSNTeamPickerViewController.h
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSNDataItemProvider.h"

@class TSNLeagueItem, TSNSportsItem;

@interface TSNTeamPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DataProviderDelegate>

@property (nonatomic, strong) TSNSportsItem *sport;
@property (nonatomic, strong) TSNLeagueItem *league;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
