//
//  TSNNewsDetailView.h
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSNNewsItem;

@interface TSNNewsDetailView : UIView

@property (nonatomic, strong) UIButton *moreButton; 
- (id)initWithFrame:(CGRect)frame newsItem:(TSNNewsItem *)newsItem;
- (void)layoutNewsContent;

@end
