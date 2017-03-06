//
//  MSEEventTest.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/20/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MSEEvent.h"

@interface MSEEventTest : XCTestCase

@property (nonatomic, strong) MSEEvent *event;

@end

@implementation MSEEventTest

- (void)setUp {
    [super setUp];
    
    NSDictionary *dictionary = @{
        @"start_timestamp": @"2017-02-20 00:00:00 +0000",
        @"end_timestamp": @"2017-02-20 01:00:00 +0000",
        @"color": @1,
        @"id": @1,
        @"name": @"Event 1"
    };
    self.event = [[MSEEvent alloc] initWithDictionary:dictionary];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitDictionary {
    XCTAssert(self.event.color == Blue);
    XCTAssert([self.event.name isEqualToString:@"Event 1"]);
    XCTAssert(self.event.length == 60);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss +zzzz";
    NSDate *date = [dateFormatter dateFromString:@"2017-02-20 00:00:00 +0000"];
    XCTAssert([self.event.date isEqualToDate:date]);
}

- (void)testInitDictionary2 {
    NSDictionary *dictionary = @{
                                 @"start_timestamp": @"2017-02-24 00:00:00 +0000",
                                 @"end_timestamp": @"2017-02-24 01:45:00 +0000",
                                 @"color": @3,
                                 @"id": @1,
                                 @"name": @"Event 2"
                                 };
    self.event = [[MSEEvent alloc] initWithDictionary:dictionary];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss +zzzz";
    NSDate *date = [dateFormatter dateFromString:@"2017-02-24 00:00:00 +0000"];
    
    XCTAssert(self.event.color == Red);
    XCTAssert([self.event.name isEqualToString:@"Event 2"]);
    XCTAssert(self.event.length == 105);
    XCTAssert([self.event.date isEqualToDate:date]);

}

- (void)testLengthString {
    XCTAssert([self.event.lengthString isEqualToString:@"1h"]);
    self.event.length = 105;
    XCTAssert([self.event.lengthString isEqualToString:@"1h45m"]);
    self.event.length = 10;
    XCTAssert([self.event.lengthString isEqualToString:@"10m"]);
}

- (void)testTimeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss +zzzz";

    XCTAssert([self.event.timeString isEqualToString:@"4:00 PM"]);
    
    NSDate *date = [dateFormatter dateFromString:@"2017-02-20 02:15:00 +0000"];
    self.event.date = date;
    XCTAssert([self.event.timeString isEqualToString:@"6:15 PM"]);
    
    date = [dateFormatter dateFromString:@"2017-02-21 08:33:00 +0000"];
    self.event.date = date;
    XCTAssert([self.event.timeString isEqualToString:@"12:33 AM"]);
    
    date = [dateFormatter dateFromString:@"2017-02-21 20:00:00 +0000"];
    self.event.date = date;
    XCTAssert([self.event.timeString isEqualToString:@"12:00 PM"]);
}
@end
