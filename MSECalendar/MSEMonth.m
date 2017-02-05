//
//  MSEMonth.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/1/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSEMonth.h"
#import "MSECalendarUtils.h"

@implementation MSEMonth

- (NSUInteger) numberOfDays {
    MSECalendarUtils *utils = [MSECalendarUtils new];
    return [utils numberOfDaysInMonth:self.month year:self.year];
}

- (NSUInteger)startingWeekDay {
    MSECalendarUtils *utils = [MSECalendarUtils new];
    return [utils firstDayInMonth:self.month year:self.year];
}

@end
