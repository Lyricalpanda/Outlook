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

- (NSString *)timeString {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self.date];
    NSInteger hour = [components hour];
    NSString *amPM = hour >= 12 ? @"PM" : @"AM";
    hour = hour % 12;
    if (hour == 0) {
        hour = 12;
    }
    NSInteger minute = [components minute];
    return [NSString stringWithFormat:@"%ld:%02ld %@", hour, (long)minute, amPM];
}

- (NSString *)lengthString {
    NSInteger hourLength = self.length/60;
    NSInteger minuteLength = self.length - hourLength * 60;
    NSString *durationString = @"";
    if (hourLength > 0) {
        durationString = [NSString stringWithFormat:@"%ldh", hourLength];
    }
    if (minuteLength > 0) {
        durationString = [NSString stringWithFormat:@"%@%ldm", durationString, minuteLength];
    }
    return durationString;
}

@end
