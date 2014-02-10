//
//  TSNAppDelegate.m
//  SportsNewsDemo
//
//  Created by Joe on 2/6/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import "TSNAppDelegate.h"
#import "TSNTopNewsMasterViewController.h"
#import "TSNMyTeamsViewController.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation TSNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // enable the network activity indicator
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // setup the first two view tabs and add to the tabbar controller
    
    TSNTopNewsMasterViewController *topNewsController = [[TSNTopNewsMasterViewController alloc] initWithNibName:nil bundle:nil];
    topNewsController.title = @"Top News";
    [topNewsController.tabBarItem setImage:[UIImage imageNamed:@"newspaper"]];
    UINavigationController *newsNavController = [[UINavigationController alloc] initWithRootViewController:topNewsController];

    TSNMyTeamsViewController *myTeamsController = [[TSNMyTeamsViewController alloc] initWithNibName:nil bundle:nil];
    myTeamsController.title = @"My Teams";
    myTeamsController.managedObjectContext = [self managedObjectContext];
    [myTeamsController.tabBarItem setImage:[UIImage imageNamed:@"star"]];
    UINavigationController *teamsNavController = [[UINavigationController alloc] initWithRootViewController:myTeamsController];
    
    UITabBarController *tabbarController = [[UITabBarController alloc] init];
    [tabbarController setViewControllers:[NSArray arrayWithObjects:newsNavController, teamsNavController, nil]];
    
    self.window.rootViewController = tabbarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveContext
{
    NSError *error;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@ %@", error, error.userInfo);
            abort();
        }
    }
}

#pragma mark - Core Data Stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SportsNewsDemo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SportsNewsDemo.sqlite"];
    
    NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unexpected error %@ %@", error, error.userInfo);
        abort();
    }
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
