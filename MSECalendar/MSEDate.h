//
//  MSEDate.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/5/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSEEvent;

@interface MSEDate : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray<MSEEvent *> *events;

- (instancetype) initWithEvents:(NSArray *)events andDate:(NSDate *)date;

@end
