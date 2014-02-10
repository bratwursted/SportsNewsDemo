//
//  TSNTeamNewsViewController.m
//  SportsNewsDemo
//
//  Created by Joe on 2/9/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

// View controller manages a UITableView to display news items for a particular team. Uses the news provider class to fetch items from the ESPN API.

#import "TSNTeamNewsViewController.h"
#import "TSNNewsDetailViewController.h"
#import "TeamInfo.h"
#import "SportInfo.h"
#import "LeagueInfo.h"
#import "TSNNewsItemTableViewCell.h"
#import "TSNNewsItem.h"

@interface TSNTeamNewsViewController ()

@property (nonatomic, strong) TSNNewsItemProvider *newsProvider;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TSNTeamNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.rowHeight = 70.0;
    _tableView.tableFooterView = [UIView new];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.view = _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = [NSString stringWithFormat:@"%@ News", _team.name];
    
    // initialize the news provider, set self as the delegate, and fetch the news items
    
    _newsProvider = [[TSNNewsItemProvider alloc] init];
    _newsProvider.delegate = self;
    [_newsProvider fetchNewsForTeamID:[_team.teamID integerValue] sport:_team.sport.name league:_team.league.abbreviation withOffset:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.newsProvider newsItemCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TSNNewsItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TSNNewsItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    id itemData = [self.newsProvider newsItemAtIndex:indexPath.item];
    
    // Fetch another batch of headlines if the table view has reached the last item.
    
    if ([self.newsProvider lastNewsItem:itemData] && [self.newsProvider newsItemCount] < [self.newsProvider fetchLimit]) {
        [self.newsProvider fetchNewsForTeamID:[_team.teamID integerValue] sport:_team.sport.name league:_team.league.abbreviation withOffset:[self.newsProvider newsItemCount] + 1];
    }
    TSNNewsItem *newsItem = [TSNNewsItem newsItemWithData:itemData];
    [cell setNewsItem:newsItem];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // When the user selects a row, display the news detail view.
    
    id itemData = [self.newsProvider newsItemAtIndex:indexPath.item];
    TSNNewsItem *newsItem = [TSNNewsItem newsItemWithData:itemData];
    
    TSNNewsDetailViewController *detailController = [[TSNNewsDetailViewController alloc] initWithNibName:nil bundle:nil];
    detailController.newsItem = newsItem;
    [self.navigationController pushViewController:detailController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}

#pragma mark - News Provider delegate

- (void)shouldReloadData
{
    [self.tableView reloadData];
}

@end
