//
//  TSNDataItemProvider.m
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

// This class handles API calls to fetch data such as sport, league, and team information.

#import "TSNDataItemProvider.h"
#import "TSNEspnApiClient.h"

@interface TSNDataItemProvider ()

@property (nonatomic, strong) NSMutableArray *dataItems;
@property (nonatomic, assign) NSInteger resultsCount;

@end

@implementation TSNDataItemProvider

- (id)init
{
    self = [super init];
    if (self) {
        _dataItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithItems:(NSArray *)items
{
    self = [self init];
    if (self) {
        [_dataItems addObjectsFromArray:items];
    }
    return self;
}

- (void)fetchDataItems:(NSString *)urlString parameters:(NSDictionary *)parameters
{
    // instantiates an instance of the API client to handle the requests, prepares the parameters, and handles the response.
    
    TSNEspnApiClient *sharedClient = [TSNEspnApiClient sharedClient];
    NSDictionary *apiEntry = @{@"apikey": [sharedClient apiKey]};
    NSMutableDictionary *requestParameters = [[NSMutableDictionary alloc] initWithDictionary:apiEntry];
    if (parameters != nil) {
        [requestParameters addEntriesFromDictionary:parameters];
    }
    
    [sharedClient GET:urlString parameters:requestParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // handle success
        if ([urlString isEqualToString:@"sports"]) {
            [self loadSportsItemsFromData:responseObject];
        }
        else {
            // this is returning team data
            [self loadTeamItemsFromData:responseObject];
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Unexpected error %@ %@", error, error.userInfo);
    }];
}

- (void)loadTeamItemsFromData:(id)responseData
{
    // loads team information into the data array, alerts the delegate that there is fresh data to be displayed.
    self.resultsCount = [[responseData valueForKey:@"resultsCount"] integerValue];
    NSArray *teamItems = [[[responseData valueForKey:@"sports"][0] valueForKey:@"leagues"][0] valueForKey:@"teams"];
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"location" ascending:YES];
    [self.dataItems addObjectsFromArray:[teamItems sortedArrayUsingDescriptors:@[sorter]]];
    [self.delegate shouldRefreshView];
}

- (void)fetchTeamItemsForSport:(NSString *)sportName andLeague:(NSString *)leagueAbbreviation
{
    // used by the Team Picker controller to get a list of teams for a particular sport and league.
    NSString *requestPath = [NSString stringWithFormat:@"sports/%@/%@/teams", sportName, leagueAbbreviation];
    NSDictionary *parameters = @{@"limit": [NSNumber numberWithInt:0]};
    [self fetchDataItems:requestPath parameters:parameters];
}

- (void)loadSportsItemsFromData:(id)responseData
{
    // loads the list of sports into the dayta array, alerts the delegate that there is fresh data to be displayed.
    NSArray *sportsItems = [responseData valueForKey:@"sports"];
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [self.dataItems addObjectsFromArray:[sportsItems sortedArrayUsingDescriptors:@[sorter]]];
    [self.delegate shouldRefreshView];
}

- (void)fetchSportsItems
{
    // used by the Sports Master controller to fetch the list of sports
    NSString *requestPath = @"sports";
    [self fetchDataItems:requestPath parameters:nil];
}

- (NSInteger)itemCount
{
    return [self.dataItems count];
}

- (id)itemAtIndex:(NSInteger)index
{
    return [self.dataItems objectAtIndex:index];
}

@end
