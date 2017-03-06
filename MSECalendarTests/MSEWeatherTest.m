//
//  MSEWeatherTest.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/20/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MSEWeather.h"

@interface MSEWeatherTest : XCTestCase

@property (nonatomic, strong) MSEWeather *weather;

@end

@implementation MSEWeatherTest

- (void)setUp {
    [super setUp];
    NSDictionary *dictionary = @{@"high" : @{
                                         @"fahrenheit" : @55
                                         },
                                 @"low" : @{
                                         @"fahrenheit" : @40
                                         },
                                 @"icon_url" : @"http://testURL"};
    self.weather = [[MSEWeather alloc] initWithDictionary:dictionary];
}


- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithDictionary {
    XCTAssert(self.weather.high == [[NSNumber numberWithInteger:55] integerValue]);
    XCTAssert(self.weather.low == [[NSNumber numberWithInteger:40] integerValue]);
    XCTAssert([self.weather.imageURL isEqualToString:@"http://testURL"]);
    XCTAssertFalse(self.weather.high == 40);
    XCTAssertFalse(self.weather.low == 55);
}

@end
