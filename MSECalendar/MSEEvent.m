//
//  MSEEvent.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/9/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSEEvent.h"
#import "MSECalendarUtils.h"

@implementation MSEEvent

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = [dictionary objectForKey:@"name"];
        self.color = [[dictionary objectForKey:@"color"] integerValue];
        self.date = [dictionary objectForKey:@"start_timestamp"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss +zzzz";
        self.date = [dateFormatter dateFromString:[dictionary objectForKey:@"start_timestamp"]];
        
        self.length = [MSECalendarUtils minutesBetweenDate:self.date andDate:[dateFormatter dateFromString:[dictionary objectForKey:@"end_timestamp"]]];
    }
    return self;
}

@end
