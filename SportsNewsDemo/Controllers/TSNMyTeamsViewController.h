//
//  TSNMyTeamsViewController.h
//  SportsNewsDemo
//
//  Created by Joe on 2/6/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSNSportsMasterViewController.h"

@interface TSNMyTeamsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIAlertViewDelegate, SportsMasterDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
