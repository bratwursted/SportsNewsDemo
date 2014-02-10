//
//  TSNNewsItemTableViewCell.m
//  SportsNewsDemo
//
//  Created by Joe on 2/6/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

// A subclass of UITableViewCell to display the headline and image for a news item. Uses the AFNetworking UIImageView category to display an image fetched from a remote server. 

#import "TSNNewsItemTableViewCell.h"
#import "TSNNewsItem.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageExtras.h"

@implementation TSNNewsItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font = [UIFont systemFontOfSize:18.0];
        self.textLabel.numberOfLines = 0; 
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)setNewsItem:(TSNNewsItem *)newsItem
{
    _newsItem = newsItem;
    
    self.textLabel.text = _newsItem.headline;
    
    CGSize cellImageSize = CGSizeMake(50.0, 50.0);
    __block UIImageView *bImageView = self.imageView;
    [self.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[newsItem imageURL]] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        // crop and set image
        bImageView.image = [image imageByScalingAndCroppingForSize:cellImageSize];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"There was an unexpected error %@ %@", error, error.userInfo);
    }];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10.0, 10.0, 50.0, 50.0);
    self.textLabel.frame = CGRectMake(80.0, 10.0, 220.0, 50.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
