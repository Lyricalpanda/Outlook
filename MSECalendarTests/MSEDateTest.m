//
//  MSEDateTest.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/20/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MSEEvent.h"
#import "MSEDate.h"

@interface MSEDateTest : XCTestCase

@property (nonatomic, strong) NSDictionary *eventDict1;
@property (nonatomic, strong) NSDictionary *eventDict2;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation MSEDateTest

- (void)setUp {
    [super setUp];
    self.eventDict1 = @{
                                 @"start_timestamp": @"2017-02-20 00:00:00 +0000",
                                 @"end_timestamp": @"2017-02-20 01:00:00 +0000",
                                 @"color": @1,
                                 @"id": @1,
                                 @"name": @"Event 1"
                                 };
    
    self.eventDict2 = @{
                                 @"start_timestamp": @"2017-02-20 00:00:00 +0000",
                                 @"end_timestamp": @"2017-02-20 01:00:00 +0000",
                                 @"color": @1,
                                 @"id": @1,
                                 @"name": @"Event 1"
                                 };
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss +zzzz";
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitWithNilEvents {
    NSDate *formatDate = [self.dateFormatter dateFromString:@"2017-02-20 00:00:00 +0000"];

    MSEDate *initDate = [[MSEDate alloc] initWithEvents:nil andDate:formatDate];
    
    XCTAssert([initDate.events count] == 0);
    XCTAssert([initDate.monthName isEqualToString:@"February"]);
    XCTAssert([initDate.monthAbbreviation isEqualToString:@"Feb"]);
    XCTAssert(initDate.month == 2);
    XCTAssert(initDate.day == 19);
    XCTAssert(initDate.year == 2017);
}

- (void)testInitWithEvents {
    MSEEvent *event1 = [[MSEEvent alloc] initWithDictionary:self.eventDict1];
    MSEEvent *event2 = [[MSEEvent alloc] initWithDictionary:self.eventDict2];
    
    NSDate *formatDate = [self.dateFormatter dateFromString:@"2017-02-20 00:00:00 +0000"];
    
    MSEDate *initDate = [[MSEDate alloc] initWithEvents:@[event1,event2] andDate:formatDate];
    
    XCTAssert([initDate.events count] == 2);
    XCTAssert([initDate.monthName isEqualToString:@"February"]);
    XCTAssert([initDate.monthAbbreviation isEqualToString:@"Feb"]);
    XCTAssert(initDate.month == 2);
    XCTAssert(initDate.day == 19);
    XCTAssert(initDate.year == 2017);
}

- (void)testProperties {
    NSDate *formatDate = [self.dateFormatter dateFromString:@"2017-03-10 00:00:00 +0000"];
    
    MSEDate *initDate = [[MSEDate alloc] initWithEvents:nil andDate:formatDate];
    XCTAssert([initDate.monthName isEqualToString:@"March"]);
    XCTAssert([initDate.monthAbbreviation isEqualToString:@"Mar"]);
    XCTAssert(initDate.month == 3);
    XCTAssert(initDate.day == 9);
    XCTAssert(initDate.year == 2017);

    formatDate = [self.dateFormatter dateFromString:@"2017-12-12 12:00:00 +0000"];
    initDate = [[MSEDate alloc] initWithEvents:nil andDate:formatDate];
    XCTAssert([initDate.monthName isEqualToString:@"December"]);
    XCTAssert([initDate.monthAbbreviation isEqualToString:@"Dec"]);
    XCTAssert(initDate.month == 12);
    XCTAssert(initDate.day == 12);
    XCTAssert(initDate.year == 2017);
}


@end
