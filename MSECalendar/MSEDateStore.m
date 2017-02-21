//
//  MSEDateStore.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/20/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSEDateStore.h"
#import "MSECalendarUtils.h"
#import "MSEEvent.h"
#import "MSEEventStore.h"

static MSEDateStore *mainstore;

@implementation MSEDateStore

+ (instancetype) mainStore {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainstore = [MSEDateStore new];
    });
    return mainstore;
}

- (NSArray *)weeklyDatesFor:(NSInteger)numberOfPreviousWeeks to:(NSInteger)numberOfFutureWeeks {
    NSMutableArray <MSEDate *> * weeks = [@[] mutableCopy];
    NSDate *currentWeek = [MSECalendarUtils firstDayOfWeekFromDate:[NSDate date]];
    NSDate *previousWeek = [currentWeek copy];
    NSDate *nextWeek = [currentWeek copy];
    for (int i = 0; i < numberOfPreviousWeeks; i++) {
        previousWeek = [MSECalendarUtils previousWeekFromDate:previousWeek];
        MSEDate *date = [[MSEDate alloc] initWithEvents:nil andDate:previousWeek];
        [weeks insertObject:date atIndex:0];
    }

    MSEDate *currentWeekDate = [[MSEDate alloc] initWithEvents:nil andDate:currentWeek];
    [weeks addObject:currentWeekDate];
    for (int i = 0; i < numberOfFutureWeeks; i++) {
        nextWeek = [MSECalendarUtils nextWeekFromDate:nextWeek];
        MSEDate *date = [[MSEDate alloc] initWithEvents:nil andDate:nextWeek];
        [weeks addObject:date];
    }

    return [NSArray arrayWithArray:weeks];
}

- (MSEDate *)dateForDate:(NSDate *)date {
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:date];
    NSDate* dateOnly = [calendar dateFromComponents:components];

    NSArray *events = [[MSEEventStore mainStore] eventsForDate:dateOnly];
    MSEDate *mseDate = [[MSEDate alloc] initWithEvents:events andDate:dateOnly];
    return mseDate;
}

- (MSEDate *)dateByAddingDays:(NSInteger)days to:(MSEDate *)date {
    NSDate *addedDate = [MSECalendarUtils addDays:days toDate:date.date];
    return [self dateForDate:addedDate];
}

@end
