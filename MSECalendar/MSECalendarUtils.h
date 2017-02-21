//
//  MSECalendarUtils.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/1/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSECalendarUtils : NSObject

+ (NSDate *)firstDayOfWeekFromDate:(NSDate *)date;
+ (NSDate *)previousWeekFromDate:(NSDate *)date;
+ (NSDate *)nextWeekFromDate:(NSDate *)date;

+ (NSString *)stringForDate:(NSDate *)date;

+ (NSString *)monthAbbreviationFromMonth:(NSInteger)month;
+ (NSString *)monthName:(NSInteger)month;

+ (NSDate *)addDays:(NSInteger)numDays toDate:(NSDate *)date;
+ (NSInteger)dayFromDate:(NSDate *)date;
+ (NSInteger)monthFromDate:(NSDate *)date;
+ (NSInteger)yearFromDate:(NSDate *)date;

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;
+ (NSInteger)weeksBetweenDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
+ (NSInteger)minutesBetweenDate:(NSDate *)date1 andDate:(NSDate *)date2;

@end
