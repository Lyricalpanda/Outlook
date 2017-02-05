//
//  MSECalendarUtils.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/1/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSECalendarUtils.h"

@interface MSECalendarUtils()

@property (nonatomic, strong) NSCalendar *calendar;

@end


@implementation MSECalendarUtils

- (instancetype) init {
    self = [super init];
    if (self) {
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return self;
}

//Convenience method
- (NSDate *)dateWithMonth:(NSInteger)month year:(NSInteger)year {
    return [self dateWithMonth:month day:1 year:year];
}

- (NSDate *)dateWithMonth:(NSInteger)month day:(NSInteger)day year:(NSInteger)year {
    NSDateComponents *components = [NSDateComponents new];
    components.year = year;
    components.day = day;
    components.month = month;
    return [self.calendar dateFromComponents:components];
}

- (NSInteger)numberOfDaysInMonth:(NSInteger)month year:(NSInteger)year {
    NSDate *date = [self dateWithMonth:month year:year];
    return [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

- (NSInteger)firstDayInMonth:(NSInteger)month year:(NSInteger)year {
    NSDate *beginningOfMonthDate = [self dateWithMonth:month year:year];
    NSInteger firstDay = [self.calendar component:NSCalendarUnitWeekday fromDate:beginningOfMonthDate];
    return firstDay;
}
- (NSString *)monthName:(NSInteger)month {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    return [[dateFormatter standaloneMonthSymbols] objectAtIndex:(month-1)];
}

@end
