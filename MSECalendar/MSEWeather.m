//
//  MSEWeather.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/20/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSEWeather.h"

@implementation MSEWeather

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        NSDictionary *highDictionary = [dictionary objectForKey:@"high"];
        NSDictionary *lowDictionary = [dictionary objectForKey:@"low"];
        self.high = [[highDictionary objectForKey:@"fahrenheit"] integerValue];
        self.low = [[lowDictionary objectForKey:@"fahrenheit"] integerValue];
        self.imageURL = [dictionary objectForKey:@"icon_url"];
    }
    return self;
}

@end
