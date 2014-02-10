//
//  TSNNewsDetailViewController.m
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

// View controller manages a view to display the news item detail (headline, summary text, a photo if available).

#import "TSNNewsDetailViewController.h"
#import "TSNNewsItem.h"
#import "TSNNewsDetailView.h"

@interface TSNNewsDetailViewController ()

@end

@implementation TSNNewsDetailViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    // initialize the custom view that handles all of the content layout and add it as a subview.
    TSNNewsDetailView *newsView = [[TSNNewsDetailView alloc] initWithFrame:self.view.bounds newsItem:_newsItem];
    [newsView layoutNewsContent];
    [newsView.moreButton addTarget:self action:@selector(launchArticle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newsView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)launchArticle:(id)sender
{
    // Present a modal view to display the full article when the user touches the "read more" button.
    TSNArticleViewController *articleController = [[TSNArticleViewController alloc] initWithNibName:nil bundle:nil];
    articleController.articleURL = _newsItem.articleURL;
    articleController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:articleController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)shouldDismissArticle
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
