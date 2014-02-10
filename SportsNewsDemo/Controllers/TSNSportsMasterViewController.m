//
//  TSNSportsMasterViewController.m
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

// View controller manages a UITableView to display the sports available from the ESPN API. USes the data provider class to fetch items from the API.

#import "TSNSportsMasterViewController.h"
#import "TSNSportsItem.h"
#import "TSNSportsLeaguesViewController.h"

@interface TSNSportsMasterViewController ()

@property (nonatomic, strong) TSNDataItemProvider *dataProvider;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TSNSportsMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        self.title = @"All Sports";
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.view = _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    
    // initialize teh data provide, set self as the delegate, and fetch the sports items
    
    _dataProvider = [[TSNDataItemProvider alloc] init];
    _dataProvider.delegate = self;
    [_dataProvider fetchSportsItems];
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
    return [self.dataProvider itemCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    TSNSportsItem *sport = [TSNSportsItem sportsItemWithData:[self.dataProvider itemAtIndex:indexPath.item]];
    cell.textLabel.text = sport.displayName;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // when the user selects a row, display the leagues associated with that sport
    
    id sportData = [self.dataProvider itemAtIndex:indexPath.item];
    TSNSportsItem *sportsItem = [TSNSportsItem sportsItemWithData:sportData];
    
    TSNSportsLeaguesViewController *leaguesController = [[TSNSportsLeaguesViewController alloc] initWithNibName:nil bundle:nil];
    leaguesController.leagueItems = sportsItem.leagues;
    leaguesController.sport = sportsItem; 
    leaguesController.managedObjectContext = _managedObjectContext;
    [self.navigationController pushViewController:leaguesController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - data provder delegate

- (void)shouldRefreshView
{
    [self.tableView reloadData];
}

#pragma mark - actions

- (void)cancel:(id)sender
{
    [self.delegate dismissSportsView];
}

- (void)donePicking
{
    // Alert the delegate to dismiss this view when the user is done managing teams.
    
    [self.delegate dismissSportsView];
}

@end
