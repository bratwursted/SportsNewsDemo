//
//  TSNNewsItemProvider.h
//  SportsNewsDemo
//
//  Created by Joe on 2/6/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewsProviderDelegate <NSObject>

- (void)shouldReloadData;

@end

@interface TSNNewsItemProvider : NSObject

@property (nonatomic, assign) NSInteger fetchLimit;
@property (nonatomic, weak) id<NewsProviderDelegate> delegate;
- (NSInteger)newsItemCount;
- (id)newsItemAtIndex:(NSInteger)index;
- (BOOL)lastNewsItem:(id)newsItem; 
- (void)fetchTopHeadlinesWithOffset:(NSInteger)offset;
- (void)fetchNewsForTeamID:(NSInteger)teamID sport:(NSString *)sport league:(NSString *)league withOffset:(NSInteger)offset;

// for testing
- (id)initWithNewsItems:(NSArray *)newsItems;

@end
