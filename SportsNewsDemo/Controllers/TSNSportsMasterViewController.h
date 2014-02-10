//
//  TSNSportsMasterViewController.h
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSNDataItemProvider.h"

@protocol SportsMasterDelegate <NSObject>

- (void)dismissSportsView;

@end

@interface TSNSportsMasterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DataProviderDelegate>

@property (nonatomic, weak) id<SportsMasterDelegate> delegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext; 
- (void)donePicking;

@end
