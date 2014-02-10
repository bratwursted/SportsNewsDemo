//
//  TSNNewsItemProvider.m
//  SportsNewsDemo
//
//  Created by Joe on 2/6/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

// This class handles API calls to fetch news headlines

#import "TSNNewsItemProvider.h"
#import "TSNEspnApiClient.h"
#import "TSNNewsItemTableViewCell.h"
#import "TSNNewsItem.h"

@interface TSNNewsItemProvider ()

@property (nonatomic, strong) NSMutableArray *newsItems;
- (void)fetchNews:(NSString *)urlString parameters:(NSDictionary *)parameters;

@end

@implementation TSNNewsItemProvider

- (id)init
{
    self = [super init];
    if (self) {
        _newsItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithNewsItems:(NSArray *)newsItems
{
    self = [super init];
    if (self) {
        _newsItems = [[NSMutableArray alloc] initWithArray:newsItems];
    }
    return self;
}

- (void)fetchNews:(NSString *)urlString parameters:(NSDictionary *)parameters
{
    // instatiates an instance of the API client, assembles the request parameters and then handles the response. The delegate method lets the delegate know there is fresh data to be displayed.
    
    TSNEspnApiClient *client = [TSNEspnApiClient sharedClient];
    NSDictionary *apiEntry = @{@"apikey": client.apiKey};
    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionaryWithDictionary:apiEntry];
    [requestParameters addEntriesFromDictionary:parameters];
    [client GET:urlString parameters:requestParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // handle success
        self.fetchLimit = [[responseObject valueForKey:@"resultsCount"] integerValue];
        NSArray *feedItems = [urlString isEqualToString:@"now/top"] ? [responseObject valueForKey:@"feed"] : [responseObject valueForKey:@"headlines"];
        [self.newsItems addObjectsFromArray:feedItems];
        [self.delegate shouldReloadData];
    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"There was an unexpected error %@ %@", error, error.userInfo);
    }];
}

- (void)fetchTopHeadlinesWithOffset:(NSInteger)offset
{
    // used by the Top Headlines controller
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:offset], @"offset", nil];
    [self fetchNews:@"now/top" parameters:parameters];
}

- (void)fetchNewsForTeamID:(NSInteger)teamID sport:(NSString *)sport league:(NSString *)league withOffset:(NSInteger)offset
{
    // used by the team news controller
    NSDictionary *parameters = @{@"teams": [NSNumber numberWithInteger:teamID],
                                 @"offset": [NSNumber numberWithInteger:offset]};
    NSString *requestPath = [NSString stringWithFormat:@"sports/%@/%@/news", sport, league];
    [self fetchNews:requestPath parameters:parameters];
}

- (NSInteger)newsItemCount
{
    // returns the current number of news items
    return self.newsItems.count;
}

- (id)newsItemAtIndex:(NSInteger)index
{
    // returns the requested news item
    return [self.newsItems objectAtIndex:index];
}

- (BOOL)lastNewsItem:(id)newsItem
{
    // compares newsItem to the last item in the array, returns true if they are equal
    id lastItem = [_newsItems lastObject];
    if (newsItem == lastItem) {
        return YES;
    }
    return NO;
}

@end
