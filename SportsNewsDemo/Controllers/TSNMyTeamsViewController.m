//
//  TSNMyTeamsViewController.m
//  SportsNewsDemo
//
//  Created by Joe on 2/6/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

// View controller that manages a UITableView to display the user's favorite teams. An edit button allows the user to delete teams and an add button launches a modal view to pick additional teams. Uses a fetched results controller to fetch the teams from Core Data.

#import "TSNMyTeamsViewController.h"
#import "TSNTeamTableViewCell.h"
#import "TeamInfo.h"
#import "TSNTeamNewsViewController.h"

@interface TSNMyTeamsViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TSNMyTeamsViewController

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
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.view = _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTeam:)];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"There was an unexpected error %@ %@", error, error.userInfo);
        exit(-1);
    }
    [self.tableView reloadData];
    if ([self.fetchedResultsController.fetchedObjects count] == 0) {
        // alert user to add teams if there are no teams yet
        NSString *message = @"Tap OK to start following your favorite teams!";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add a Team" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *titles = [self.fetchedResultsController sectionIndexTitles];
    return [titles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TSNTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TSNTeamTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell setTeam:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // delete row from data source
        TeamInfo *team = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [_managedObjectContext deleteObject:team];
        NSError *error;
        if (![_managedObjectContext save:&error]) {
            NSLog(@"There was an unexpected error %@ %@", error, error.userInfo);
            exit(-1);
        }
    }
    
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        // add row to data source
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // When the user selects a row, display the new items for that team.
    
    TSNTeamNewsViewController *newsController = [[TSNTeamNewsViewController alloc] initWithNibName:nil bundle:nil];
    newsController.team = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:newsController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TeamInfo" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *leagueSort = [NSSortDescriptor sortDescriptorWithKey:@"league.name" ascending:YES];
    NSSortDescriptor *locationSort = [NSSortDescriptor sortDescriptorWithKey:@"location" ascending:YES];
    [fetchRequest setSortDescriptors:@[leagueSort, locationSort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:@"league.name" cacheName:nil];
    self.fetchedResultsController = controller;
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

- (NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName
{
    return sectionName;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch (type) {
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    UITableView *tableView = self.tableView;
    
    switch (type) {
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self addTeam:self];
    }
}

#pragma mark - new teams

- (void)addTeam:(id)sender
{
    // launches the modal view controller to pick new teams
    
    if (self.tableView.editing) {
        [self.tableView setEditing:NO animated:YES];
    }
    
    TSNSportsMasterViewController *controller = [[TSNSportsMasterViewController alloc] initWithNibName:nil bundle:nil];
    controller.delegate = self;
    controller.managedObjectContext = _managedObjectContext;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navController animated:YES completion:nil];
    self.fetchedResultsController = nil;
}

- (void)dismissSportsView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
