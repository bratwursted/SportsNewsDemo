//
//  TSNArticleViewController.h
//  SportsNewsDemo
//
//  Created by Joe on 2/7/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ArticleViewDelegate <NSObject>

- (void)shouldDismissArticle;

@end

@interface TSNArticleViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSURL *articleURL;
@property (nonatomic, weak) id<ArticleViewDelegate> delegate;

@end
