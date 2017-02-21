//
//  MSEEventStore.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/19/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSEEventStore.h"
#import "MSEEvent.h"
#import "MSECalendarUtils.h"

static MSEEventStore *mainStore;

@interface MSEEventStore()

@property (nonatomic, strong) NSMutableArray *eventsArray;

@end

@implementation MSEEventStore

+ (instancetype)mainStore {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainStore = [MSEEventStore new];
        [mainStore initStore];
    });
    
    return mainStore;
}

- (void)initStore {
    self.eventsArray = [@[] mutableCopy];

    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"events" ofType:@"json"]];
    NSError *error;
    NSDictionary * eventsJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    for (NSDictionary *eventDict in eventsJson[@"events"]) {
        MSEEvent *event = [[MSEEvent alloc] initWithDictionary:eventDict];
        [self.eventsArray addObject:event];
    }
}

- (NSArray *)eventsForDate:(NSDate *)date {
    NSDate *nextDay = [MSECalendarUtils addDays:1 toDate:date];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date < %@)", date, nextDay];
        
    NSMutableArray *results = [[NSArray arrayWithArray:self.eventsArray] mutableCopy];
    [results filterUsingPredicate:predicate];
    return results;
}

@end
