//
//  MSECalendarUtils.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/1/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSECalendarUtils : NSObject

- (NSDate *)dateWithMonth:(NSInteger)month year:(NSInteger)year;
- (NSDate *)dateWithMonth:(NSInteger)month day:(NSInteger)day year:(NSInteger)year;
- (NSInteger)numberOfDaysInMonth:(NSInteger)month year:(NSInteger)year;
- (NSInteger)firstDayInMonth:(NSInteger)month year:(NSInteger)year;
- (NSString *)monthName:(NSInteger)month;
@end
