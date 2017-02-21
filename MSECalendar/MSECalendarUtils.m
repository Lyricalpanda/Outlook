//
//  MSECalendarUtils.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/1/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSECalendarUtils.h"

static MSECalendarUtils *mainstore;
static NSCalendar *calendar;

@interface MSECalendarUtils()

@property (nonatomic, strong) NSCalendar *calendar;

@end


@implementation MSECalendarUtils

+ (void)initialize {
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
}

+ (NSDate *)firstDayOfWeekFromDate:(NSDate *)date {
    NSDate *firstDay;
    NSInteger weekdayOfDate = [calendar component:NSCalendarUnitWeekday fromDate:date];
    if (weekdayOfDate > 1) {
        firstDay = [self addDays:-1*(weekdayOfDate-1) toDate:date];
    }
    else {
        firstDay = [date copy];
    }
    return firstDay;

}

+ (NSDate *)previousWeekFromDate:(NSDate *)date{
    return [MSECalendarUtils addDays:-7 toDate:date];
}

+ (NSDate *)nextWeekFromDate:(NSDate *)date{
    return [MSECalendarUtils addDays:7 toDate:date];
}

+ (NSDate *)addDays:(NSInteger)numDays toDate:(NSDate *)date {
    NSUInteger units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:units fromDate:date];
    comps.day = comps.day + numDays;
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

+ (NSString *)stringForDate:(NSDate *)date{
    return [[NSString stringWithFormat:@"%@ %@ %ld",[MSECalendarUtils weekdayName:[calendar component:NSCalendarUnitWeekday fromDate:date]], [MSECalendarUtils monthName:[calendar component:NSCalendarUnitMonth fromDate:date]], [calendar component:NSCalendarUnitDay fromDate:date]] uppercaseString];
}

+ (NSString *)monthName:(NSInteger)month {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    return [[dateFormatter standaloneMonthSymbols] objectAtIndex:(month-1)];
}

+ (NSString *)weekdayName:(NSInteger)day {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    return [[dateFormatter weekdaySymbols] objectAtIndex:(day-1)];
}

+ (NSInteger)dayFromDate:(NSDate *)date {
    return [[calendar components: NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date] day];

}

+ (NSInteger)monthFromDate:(NSDate *)date {
    return [[calendar components: NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date] month];
}

+ (NSInteger)yearFromDate:(NSDate *)date {
    return [[calendar components: NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date] year];
}

+ (NSString *)monthAbbreviationFromMonth:(NSInteger)month {
    return [[MSECalendarUtils monthName:month] substringToIndex:3];
}

+ (NSInteger)weeksBetweenDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSDate *fromDateA;
    NSDate *toDateA;
    
    [calendar rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&fromDateA
                 interval:NULL forDate:fromDate];
    [calendar rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&toDateA
                 interval:NULL forDate:toDate];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitWeekOfYear
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference weekOfYear];
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDate andDate:(NSDate*)toDate
{
    NSDate *fromDateA;
    NSDate *toDateA;
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDateA
                      interval:NULL forDate:fromDate];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDateA
                      interval:NULL forDate:toDate];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                                    fromDate:fromDateA toDate:toDateA options:0];
    
    return [difference day];
}

+ (NSInteger)minutesBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2 {
    return fabs([date1 timeIntervalSinceDate:date2]) / 60;
}

@end
