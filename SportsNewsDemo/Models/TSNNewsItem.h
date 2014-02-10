//
//  TSNNewsItem.h
//  SportsNewsDemo
//
//  Created by Joe on 2/6/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSNNewsItem : NSObject

+ (instancetype)newsItemWithData:(NSDictionary *)itemData;

- (NSString *)headline;
- (NSString *)summary;
- (NSString *)source;
- (NSDate *)publishedDate;
- (NSURL *)imageURL;
- (CGSize)imageSize;
- (NSURL *)articleURL; 

@end
