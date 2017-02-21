//
//  MSEDate.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/5/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSEDate.h"
#import "MSECalendarUtils.h"

@implementation MSEDate

- (instancetype) initWithEvents:(NSArray *)events andDate:(NSDate *)date {
    self = [super init];
    if (self) {
        _date = date;
        _events = events;
        _year = [MSECalendarUtils yearFromDate:date];
        _month = [MSECalendarUtils monthFromDate:date];
        _day = [MSECalendarUtils dayFromDate:date];
    }
    return self;
}

- (NSString *)monthAbbreviation {
    return [MSECalendarUtils monthAbbreviationFromMonth:self.month];
}

- (NSString *)monthName {
    return [MSECalendarUtils monthName:self.month];
}

- (NSString *)toString {
    NSLog(@"Date: %@", self.date);
    NSLog(@"Date2 : %@", [MSECalendarUtils stringForDate:self.date] );
    return [MSECalendarUtils stringForDate:self.date];
}

@end
