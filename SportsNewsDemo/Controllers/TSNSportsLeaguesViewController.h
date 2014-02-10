//
//  TSNSportsLeaguesViewController.h
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSNSportsItem;

@interface TSNSportsLeaguesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *leagueItems;
@property (nonatomic, strong) TSNSportsItem *sport;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
