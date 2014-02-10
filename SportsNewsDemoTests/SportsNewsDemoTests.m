//
//  SportsNewsDemoTests.m
//  SportsNewsDemoTests
//
//  Created by Joe on 2/6/14.
//  Copyright (c) 2014 Thinx. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TSNNewsItemProvider.h"
#import "TSNDataItemProvider.h"

@interface SportsNewsDemoTests : XCTestCase

@end

@implementation SportsNewsDemoTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNewsProvider
{
    NSArray *testItems = @[
                           @{@"headline": @"Packers Win Big Game",
                             @"description": @"It was a really great game for sure.",
                             @"source": @"ESPN"},
                           @{@"headline": @"Can The Yankees Win It All?",
                             @"description": @"Who knows if they can win another World Series championship.",
                             @"source": @"MLB.com"},
                           @{@"headline": @"Worst Team In The NBA?",
                             @"description": @"The Knicks could be the worst in history.",
                             @"source": @"ESPN.com"}
                           ];
    TSNNewsItemProvider *newsProvider = [[TSNNewsItemProvider alloc] initWithNewsItems:testItems];
    [self assertNewsProvider:newsProvider returnsCorrectCount:3];
    [self assertArticle:[newsProvider newsItemAtIndex:1] hasCorrectHeadline:@"Can The Yankees Win It All?"];
}

- (void)assertNewsProvider:(TSNNewsItemProvider *)newsProvider returnsCorrectCount:(NSInteger)expectedCount
{
    NSInteger count = [newsProvider newsItemCount];
    XCTAssertTrue(count == expectedCount, @"The count is correct");
}

- (void)assertArticle:(id)article hasCorrectHeadline:(NSString *)expectedHeadline
{
    NSString *title = [article valueForKey:@"headline"];
    XCTAssertEqual(title, expectedHeadline, @"The correct article was selected.");
}

- (void)testDataProvider
{
    NSArray *testItems = @[
                           @{
                               @"name": @"Packers",
                               @"location": @"Green Bay"
                               },
                           @{
                               @"name": @"Mets",
                               @"location": @"New York"
                               },
                           @{
                               @"name": @"Devils",
                               @"location": @"New Jersey"
                               }
                           ];
    TSNDataItemProvider *dataProvider = [[TSNDataItemProvider alloc] initWithItems:testItems];
    [self assertDataProvider:dataProvider returnsTheCorrectCount:3];
    [self assertTeam:[dataProvider itemAtIndex:0] hasCorrectName:@"Packers"];
}

- (void)assertDataProvider:(TSNDataItemProvider *)dataProvider returnsTheCorrectCount:(NSInteger)expectedCount
{
    XCTAssertTrue([dataProvider itemCount] == expectedCount, @"The item count is correct");
}

- (void)assertTeam:(id)teamInfo hasCorrectName:(NSString *)expectedName
{
    XCTAssertEqual([teamInfo valueForKey:@"name"], expectedName, @"The team name is correct");
}

@end
