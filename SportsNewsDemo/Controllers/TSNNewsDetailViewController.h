//
//  TSNNewsDetailViewController.h
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSNArticleViewController.h"

@class TSNNewsItem;

@interface TSNNewsDetailViewController : UIViewController <ArticleViewDelegate>

@property (nonatomic, strong) TSNNewsItem *newsItem; 

@end
