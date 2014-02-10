//
//  TSNTeamPickerViewController.m
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

// View controller manages a UITableView to display the teams associated with a particular sport and league. Uses the data provider class to fetch the team items from the ESPN API.

#import "TSNTeamPickerViewController.h"
#import "TSNSportsMasterViewController.h"
#import "TSNLeagueItem.h"
#import "TSNTeamItem.h"
#import "TSNSportsItem.h"
#import "TeamInfo+Picker.h"
#import "SportInfo.h"

@interface TSNTeamPickerViewController ()

@property (nonatomic, strong) TSNDataItemProvider *dataProvider;
@property (nonatomic, strong) NSMutableArray *favoriteTeams;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TSNTeamPickerViewController

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
    self.tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.view = _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = [NSString stringWithFormat:@"%@ Teams", _league.shortName];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.favoriteTeams = [self fetchFavorites];
    
    // initialize the data provider, set self as delegate, and fetch the teams
    
    self.dataProvider = [[TSNDataItemProvider alloc] init];
    _dataProvider.delegate = self;
    [_dataProvider fetchTeamItemsForSport:[_sport name] andLeague:[_league abbreviation]];
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
    }
    id teamData = [self.dataProvider itemAtIndex:indexPath.item];
    TSNTeamItem *teamItem = [TSNTeamItem teamItemWithData:teamData];
    cell.textLabel.text = [teamItem fullName];
    
    // display a checkmark if the team is already a favorite
    if ([self isFavorite:teamItem]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id teamData = [self.dataProvider itemAtIndex:indexPath.item];
    TSNTeamItem *teamItem = [TSNTeamItem teamItemWithData:teamData];
    if ([self isFavorite:teamItem]) {
        // remove this team from the list of favorites
        TeamInfo *team = [TeamInfo teamForTeamItem:teamItem league:_league inManagedObjectContext:_managedObjectContext];
        [_managedObjectContext deleteObject:team];
        NSError *error;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"There was an unexpected error %@ %@", error, error.userInfo);
        }
        [self.favoriteTeams removeObject:team];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    } else {
        // add this team to the list of favorites
        TeamInfo *newTeam = [NSEntityDescription insertNewObjectForEntityForName:@"TeamInfo" inManagedObjectContext:_managedObjectContext];
        [newTeam addFavorite:teamItem sport:_sport league:_league];
        [self.favoriteTeams addObject:newTeam];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Data provider delegate

- (void)shouldRefreshView
{
    [self.tableView reloadData];
}

#pragma mark - Team methods

- (NSMutableArray *)fetchFavorites
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TeamInfo"];
    NSError *error;
    NSArray *results = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"There was an unexpected error %@ %@", error, error.userInfo);
    }
    return [results mutableCopy];
}

- (BOOL)isFavorite:(TSNTeamItem *)teamItem
{
    for (TeamInfo *team in _favoriteTeams) {
        if ([team.teamID integerValue] == teamItem.teamID && [team.sport.name isEqualToString:_sport.name]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Action

- (void)done:(id)sender
{
    TSNSportsMasterViewController *masterController = (TSNSportsMasterViewController *)[self.navigationController.viewControllers firstObject];
    [masterController donePicking];
}

@end
