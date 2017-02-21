//
//  MSEDateStore.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/20/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSEDate.h"

@interface MSEDateStore : NSObject

+ (instancetype) mainStore;
- (NSArray *)weeklyDatesFor:(NSInteger)numberOfPreviousWeeks to:(NSInteger)numberOfFutureWeeks;
- (MSEDate *)dateForDate:(NSDate *)date;
- (MSEDate *)dateByAddingDays:(NSInteger)days to:(MSEDate *)date;
@end
