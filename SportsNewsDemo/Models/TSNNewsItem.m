//
//  TSNNewsItem.m
//  SportsNewsDemo
//
//  Created by Joe on 2/6/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

// A class to represent a news item returned from the API. Associated associated data is stored in a NSDictionary. Provides methods to retrieve individual properties like the headline, summary text, and image URL.  

#import "TSNNewsItem.h"

@interface TSNNewsItem ()

@property (nonatomic, strong) NSDictionary *itemData;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation TSNNewsItem

+ (instancetype)newsItemWithData:(NSDictionary *)itemData
{
    TSNNewsItem *newsItem = [[self alloc] init];
    newsItem.itemData = itemData;
    newsItem.dateFormatter = [[NSDateFormatter alloc] init];
    [newsItem.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [newsItem.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [newsItem.dateFormatter setFormatterBehavior:NSDateFormatterBehaviorDefault];
    [newsItem.dateFormatter setLocale:[NSLocale currentLocale]];
    return newsItem;
}

- (NSString *)headline
{
    NSString *headline = [_itemData valueForKey:@"headline"];
    if (headline != nil) {
        return headline;
    }
    return @"No headline available";
}

- (NSURL *)imageURL
{
    NSDictionary *imageData = [self _imageData];
    if (imageData == nil) {
        return nil;
    }
    NSString *imagePath = [imageData valueForKey:@"url"];
    if (imagePath == nil) {
        return nil;
    }
    return [NSURL URLWithString:imagePath];
}

- (CGSize)imageSize
{
    NSDictionary *imageData = [self _imageData];
    if (imageData == nil) {
        return CGSizeZero;
    }
    CGFloat width = [[imageData valueForKey:@"width"] floatValue];
    CGFloat height = [[imageData valueForKey:@"height"] floatValue];
    return CGSizeMake(width, height);
}

- (NSString *)source
{
    NSString *sourceName = [_itemData valueForKey:@"source"];
    return sourceName;
}

- (NSString *)summary
{
    NSString *articleSummary = [_itemData valueForKey:@"description"];
    if (articleSummary != nil) {
        return articleSummary;
    }
    return @"No summary available"; 
}

- (NSDate *)publishedDate
{
    NSString *dateString = [_itemData valueForKey:@"published"];
    if (dateString == nil) {
        return nil;
    }
    return [_dateFormatter dateFromString:dateString];
}

- (NSURL *)articleURL
{
    NSDictionary *links = [_itemData valueForKey:@"links"];
    NSDictionary *webLink = [links valueForKey:@"web"];
    NSString *url = [webLink valueForKey:@"href"];
    if (url == nil) {
        return nil;
    }
    return [NSURL URLWithString:url]; 
}

#pragma mark - private methods

- (NSDictionary *)_imageData
{
    NSArray *images = [_itemData valueForKey:@"images"];
    if (images == nil) {
        return nil;
    }
    return [images firstObject];
}

@end
