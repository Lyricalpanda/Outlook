//
//  MSEEventStore.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/19/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSEEventStore : NSObject

+ (instancetype) mainStore;
- (NSArray *) eventsForDate:(NSDate *)date;

@end
