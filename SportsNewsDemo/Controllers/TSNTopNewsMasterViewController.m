//
//  TSNTopNewsMasterViewController.m
//  SportsNewsDemo
//
//  Created by Joe on 2/6/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

// View controller manages a table view to display top news items fetched by the news provider.

#import "TSNTopNewsMasterViewController.h"
#import "TSNNewsItemTableViewCell.h"
#import "TSNNewsItem.h"
#import "TSNNewsDetailViewController.h"

@interface TSNTopNewsMasterViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TSNNewsItemProvider *newsProvider;

@end

@implementation TSNTopNewsMasterViewController

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

    // setup the table view
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.rowHeight = 70.0;
    tableView.tableFooterView = [UIView new];
    self.tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.view = _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // initialize the news provider, set self as the delegate and fetch the news items
    self.newsProvider = [[TSNNewsItemProvider alloc] init];
    _newsProvider.delegate = self;
    [_newsProvider fetchTopHeadlinesWithOffset:0];
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
    
    // Make another fetch call to get more news items if the table view has reached the last news item available.
    if ([self.newsProvider lastNewsItem:itemData] && [self.newsProvider newsItemCount] < self.newsProvider.fetchLimit) {
        [self.newsProvider fetchTopHeadlinesWithOffset:[self.newsProvider newsItemCount] + 1];
    }
    TSNNewsItem *newsItem = [TSNNewsItem newsItemWithData:itemData];
    [cell setNewsItem:newsItem];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // when the user selected a row, display the deatil view for that news item.
    id newsData = [self.newsProvider newsItemAtIndex:indexPath.item];
    TSNNewsItem *newsItem = [TSNNewsItem newsItemWithData:newsData];
    TSNNewsDetailViewController *detailController = [[TSNNewsDetailViewController alloc] initWithNibName:nil bundle:nil];
    detailController.newsItem = newsItem;
    [self.navigationController pushViewController:detailController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}

#pragma mark - news provider delegate

- (void)shouldReloadData
{
    [self.tableView reloadData];
}

@end
