//
//  TSNTeamNewsViewController.h
//  SportsNewsDemo
//
//  Created by Joe on 2/9/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSNNewsItemProvider.h"

@class TeamInfo;

@interface TSNTeamNewsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NewsProviderDelegate>

@property (nonatomic, strong) TeamInfo *team; 

@end
