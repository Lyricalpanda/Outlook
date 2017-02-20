//
//  MSEEvent.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/9/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MSEEventColor) {
    Blue = 1,
    Green,
    Red
};


@interface MSEEvent : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger length;
@property (nonatomic) MSEEventColor color;

- (instancetype) initWithDictionary:(NSDictionary *)dictionary;

@end
