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

- (NSDate *)firstDayOfWeekFromDate:(NSDate *)date {
    NSDate *firstDay;
    NSUInteger weekdayOfDate = [self.calendar component:NSCalendarUnitWeekday fromDate:date];
    if (weekdayOfDate > 1) {
        firstDay = [self addDays:-1*(weekdayOfDate-1) toDate:date];
    }
    else {
        firstDay = [date copy];
    }
    return firstDay;
}

- (NSInteger)weekdayOfWeekFromDate:(NSDate *)date {
    return [self.calendar component:NSCalendarUnitWeekday fromDate:date];
}

- (NSDate *)previousWeekFromDate:(NSDate *)date{
    return [self addDays:-7 toDate:date];
}

- (NSDate *)nextWeekFromDate:(NSDate *)date {
    return [self addDays:7 toDate:date];
}

- (NSDate *)addDays:(NSInteger)numDays toDate:(NSDate *)date {
    NSUInteger units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:units fromDate:date];
    comps.day = comps.day + numDays;
    return [self.calendar dateFromComponents:comps];
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

- (NSString *)weekdayName:(NSInteger)day {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    return [[dateFormatter weekdaySymbols] objectAtIndex:(day-1)];
}

- (NSInteger)dayFromDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    return [components day];
}

- (NSInteger)monthFromDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    return [components month];
}

- (NSInteger)yearFromDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    return [components year];

}

//getEra

- (NSString *)stringForDate:(NSDate *)date {
    return [[NSString stringWithFormat:@"%@ %@ %ld",[self weekdayName:[self weekdayOfWeekFromDate:date]], [self monthName:[self monthFromDate:date]], [self dayFromDate:date]] uppercaseString];
}

- (NSString *)monthAbbreviationFromMonth:(NSInteger)month {
    return [[self monthName:month] substringToIndex:3];
}

- (NSInteger)weeksBetweenDate:(NSDate *)fromDateTime toDate:(NSDate *)toDateTime {
    NSDate *fromDate;
    NSDate *toDate;
    
    [self.calendar rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&fromDate
                      interval:NULL forDate:fromDateTime];
    [self.calendar rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&toDate
                      interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [self.calendar components:NSCalendarUnitWeekOfYear
                                                    fromDate:fromDate toDate:toDate options:0];
    
    return [difference weekOfYear];
}

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    [self.calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [self.calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [self.calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

+ (NSInteger)minutesBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2 {
    return fabs([date1 timeIntervalSinceDate:date2]) / 60;
}

@end
