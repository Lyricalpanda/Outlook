//
//  MSEDate.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/5/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSEDate.h"

@implementation MSEDate

- (instancetype) initWithEvents:(NSArray *)events andDate:(NSDate *)date {
    self = [super init];
    if (self) {
        _date = date;
        _events = events;
    }
    return self;
}

@end
