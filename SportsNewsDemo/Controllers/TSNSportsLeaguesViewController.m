//
//  TSNSportsLeaguesViewController.m
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

// View controller manages a UITableView to display the leagues associated with a sport. 

#import "TSNSportsLeaguesViewController.h"
#import "TSNLeagueItem.h"
#import "TSNSportsItem.h"
#import "TSNTeamPickerViewController.h"

@interface TSNSportsLeaguesViewController ()

@end

@implementation TSNSportsLeaguesViewController

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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    self.view = tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = [NSString stringWithFormat:@"%@ Leagues", _sport.displayName];
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
    return [self.leagueItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    id leagueData = [self.leagueItems objectAtIndex:indexPath.item];
    TSNLeagueItem *league = [TSNLeagueItem leagueItemWithData:leagueData];
    cell.textLabel.text = league.name;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id leagueData = [self.leagueItems objectAtIndex:indexPath.item];
    TSNLeagueItem *league = [TSNLeagueItem leagueItemWithData:leagueData];
    
    TSNTeamPickerViewController *pickerController = [[TSNTeamPickerViewController alloc] initWithNibName:nil bundle:nil];
    pickerController.sport = _sport;
    pickerController.league = league;
    pickerController.managedObjectContext = _managedObjectContext;
    
    [self.navigationController pushViewController:pickerController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
