 //
//  MSECalendarUtilTest.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/20/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MSEDate.h"
#import "MSECalendarUtils.h"

@interface MSECalendarUtilTest : XCTestCase

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *formatDate;

@end

@implementation MSECalendarUtilTest

- (void)setUp {
    [super setUp];

    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss +zzzz";
    self.formatDate = [self.dateFormatter dateFromString:@"2017-02-20 08:00:00 +0000"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testFirstDayOfWeek {
    
    NSDate *firstDate = [MSECalendarUtils firstDayOfWeekFromDate:self.formatDate];
    XCTAssert([MSECalendarUtils dayFromDate:firstDate] == 19);
    XCTAssert([MSECalendarUtils monthFromDate:firstDate] == 2);

    //Test to make sure it works across different months
    self.formatDate = [self.dateFormatter dateFromString:@"2017-02-1 08:00:00 +0000"];
    firstDate = [MSECalendarUtils firstDayOfWeekFromDate:self.formatDate];
    XCTAssert([MSECalendarUtils dayFromDate:firstDate] == 29);
    XCTAssert([MSECalendarUtils monthFromDate:firstDate] == 1);
    
    //Test to make sure it works when it's the first day of the week
    self.formatDate = [self.dateFormatter dateFromString:@"2017-02-5 08:00:00 +0000"];
    firstDate = [MSECalendarUtils firstDayOfWeekFromDate:self.formatDate];
    XCTAssert([MSECalendarUtils dayFromDate:firstDate] == 5);
    XCTAssert([MSECalendarUtils monthFromDate:firstDate] == 2 );
}

- (void)testPreviousWeekFromDate {
    
    NSDate *firstDate = [MSECalendarUtils previousWeekFromDate:self.formatDate];
    XCTAssert([MSECalendarUtils dayFromDate:firstDate] == 13);
    XCTAssert([MSECalendarUtils monthFromDate:firstDate] == 2);
    
    self.formatDate = [self.dateFormatter dateFromString:@"2017-03-06 08:00:00 +0000"];
    firstDate = [MSECalendarUtils previousWeekFromDate:self.formatDate];
    XCTAssert([MSECalendarUtils dayFromDate:firstDate] == 27);
    XCTAssert([MSECalendarUtils monthFromDate:firstDate] == 2);
}

- (void)testNextWeekFromDate {
    
    NSDate *firstDate = [MSECalendarUtils nextWeekFromDate:self.formatDate];
    XCTAssert([MSECalendarUtils dayFromDate:firstDate] == 27);
    XCTAssert([MSECalendarUtils monthFromDate:firstDate] == 2);
    
    self.formatDate = [self.dateFormatter dateFromString:@"2017-02-27 08:00:00 +0000"];
    firstDate = [MSECalendarUtils nextWeekFromDate:self.formatDate];
    XCTAssert([MSECalendarUtils dayFromDate:firstDate] == 6);
    XCTAssert([MSECalendarUtils monthFromDate:firstDate] == 3);
}

- (void)testStringForDate {
    XCTAssert([[MSECalendarUtils stringForDate:self.formatDate] isEqualToString:@"MONDAY FEBRUARY 20"]);
}

- (void)testMonthAbbreviationFromMonth {
    XCTAssert([[MSECalendarUtils monthAbbreviationFromMonth:1] isEqualToString:@"Jan"]);
    XCTAssert([[MSECalendarUtils monthAbbreviationFromMonth:2] isEqualToString:@"Feb"]);
    XCTAssert([[MSECalendarUtils monthAbbreviationFromMonth:3] isEqualToString:@"Mar"]);
    XCTAssert([[MSECalendarUtils monthAbbreviationFromMonth:4] isEqualToString:@"Apr"]);
    XCTAssert([[MSECalendarUtils monthAbbreviationFromMonth:5] isEqualToString:@"May"]);
    XCTAssert([[MSECalendarUtils monthAbbreviationFromMonth:6] isEqualToString:@"Jun"]);
    XCTAssert([[MSECalendarUtils monthAbbreviationFromMonth:7] isEqualToString:@"Jul"]);
    XCTAssert([[MSECalendarUtils monthAbbreviationFromMonth:8] isEqualToString:@"Aug"]);
    XCTAssert([[MSECalendarUtils monthAbbreviationFromMonth:9] isEqualToString:@"Sep"]);
    XCTAssert([[MSECalendarUtils monthAbbreviationFromMonth:10] isEqualToString:@"Oct"]);
    XCTAssert([[MSECalendarUtils monthAbbreviationFromMonth:11] isEqualToString:@"Nov"]);
    XCTAssert([[MSECalendarUtils monthAbbreviationFromMonth:12] isEqualToString:@"Dec"]);
}

- (void)testMonthName {
    XCTAssert([[MSECalendarUtils monthName:1] isEqualToString:@"January"]);
    XCTAssert([[MSECalendarUtils monthName:2] isEqualToString:@"February"]);
    XCTAssert([[MSECalendarUtils monthName:3] isEqualToString:@"March"]);
    XCTAssert([[MSECalendarUtils monthName:4] isEqualToString:@"April"]);
    XCTAssert([[MSECalendarUtils monthName:5] isEqualToString:@"May"]);
    XCTAssert([[MSECalendarUtils monthName:6] isEqualToString:@"June"]);
    XCTAssert([[MSECalendarUtils monthName:7] isEqualToString:@"July"]);
    XCTAssert([[MSECalendarUtils monthName:8] isEqualToString:@"August"]);
    XCTAssert([[MSECalendarUtils monthName:9] isEqualToString:@"September"]);
    XCTAssert([[MSECalendarUtils monthName:10] isEqualToString:@"October"]);
    XCTAssert([[MSECalendarUtils monthName:11] isEqualToString:@"November"]);
    XCTAssert([[MSECalendarUtils monthName:12] isEqualToString:@"December"]);
}

- (void)testAddDaysToDate {
    NSDate *firstDate = [MSECalendarUtils addDays:3 toDate:self.formatDate];
    XCTAssert([MSECalendarUtils dayFromDate:firstDate] == 23);
    XCTAssert([MSECalendarUtils monthFromDate:firstDate] == 2);
    XCTAssert([[MSECalendarUtils stringForDate:firstDate] isEqualToString:@"THURSDAY FEBRUARY 23"]);

    firstDate = [MSECalendarUtils addDays:-3 toDate:self.formatDate];
    XCTAssert([MSECalendarUtils dayFromDate:firstDate] == 17);
    XCTAssert([MSECalendarUtils monthFromDate:firstDate] == 2);
    XCTAssert([[MSECalendarUtils stringForDate:firstDate] isEqualToString:@"FRIDAY FEBRUARY 17"]);
}

- (void)testDayFromDate {
    XCTAssert([MSECalendarUtils dayFromDate:self.formatDate] == 20);
}

- (void)testMonthFromDate {
    XCTAssert([MSECalendarUtils monthFromDate:self.formatDate] == 2);
}

- (void)testYearFromDate {
    XCTAssert([MSECalendarUtils yearFromDate:self.formatDate] == 2017);
}

- (void)testDaysBetweenDate {
    NSDate *firstDate = [MSECalendarUtils addDays:3 toDate:self.formatDate];
    XCTAssert([MSECalendarUtils daysBetweenDate:self.formatDate andDate:firstDate] == 3);
    
    firstDate = [MSECalendarUtils addDays:0 toDate:self.formatDate];
    XCTAssert([MSECalendarUtils daysBetweenDate:self.formatDate andDate:firstDate] == 0);

    firstDate = [MSECalendarUtils addDays:-4 toDate:self.formatDate];
    XCTAssert([MSECalendarUtils daysBetweenDate:self.formatDate andDate:firstDate] == -4);
}

- (void)testWeeksBetweenDate {
    NSDate *firstDate = [MSECalendarUtils addDays:7 toDate:self.formatDate];
    XCTAssert([MSECalendarUtils weeksBetweenDate:self.formatDate toDate:firstDate] == 1);
    XCTAssert([MSECalendarUtils weeksBetweenDate:firstDate toDate:self.formatDate] == -1);

    firstDate = [MSECalendarUtils addDays:21 toDate:self.formatDate];
    XCTAssert([MSECalendarUtils weeksBetweenDate:self.formatDate toDate:firstDate] == 3);
    XCTAssert([MSECalendarUtils weeksBetweenDate:firstDate toDate:self.formatDate] == -3);
}

- (void)testMinutesBetweenDate {
    NSDate *firstDate = [self.dateFormatter dateFromString:@"2017-02-20 08:21:00 +0000"];
    XCTAssert([MSECalendarUtils minutesBetweenDate:self.formatDate andDate:firstDate] == 21);

    firstDate = [self.dateFormatter dateFromString:@"2017-02-20 09:21:00 +0000"];
    XCTAssert([MSECalendarUtils minutesBetweenDate:self.formatDate andDate:firstDate] == 81);

    firstDate = [self.dateFormatter dateFromString:@"2017-02-20 07:21:00 +0000"];
    XCTAssert([MSECalendarUtils minutesBetweenDate:self.formatDate andDate:firstDate] == 39);
}

@end
