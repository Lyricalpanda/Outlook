//
//  MSEMonth.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/1/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSEMonth : NSObject

@property (nonatomic) NSUInteger month;
@property (nonatomic) NSUInteger year;

- (NSUInteger) numberOfDays;
- (NSUInteger) startingWeekDay;

@end
