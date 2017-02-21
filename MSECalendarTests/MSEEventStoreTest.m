//
//  MSEEventStoreTest.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/20/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MSEEventStore.h"

@interface MSEEventStoreTest : XCTestCase

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation MSEEventStoreTest

- (void)setUp {
    [super setUp];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss +zzzz";
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testEventsForDate {
    NSDate *formatDate = [self.dateFormatter dateFromString:@"2017-02-20 00:00:00 +0000"];
    XCTAssert([[[MSEEventStore mainStore] eventsForDate:formatDate] count] == 1);
    formatDate = [self.dateFormatter dateFromString:@"2017-02-23 00:00:00 +0000"];
    XCTAssert([[[MSEEventStore mainStore] eventsForDate:formatDate] count] == 1);
    formatDate = [self.dateFormatter dateFromString:@"2017-02-26 00:00:00 +0000"];
    XCTAssert([[[MSEEventStore mainStore] eventsForDate:formatDate] count] == 0);
}

@end
