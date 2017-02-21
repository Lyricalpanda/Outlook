//
//  MSEWeatherStore.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/20/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSEWeather.h"

@interface MSEWeatherStore : NSObject

+ (instancetype)mainstore;

- (void)fetchTenDayForcastWithSuccessBlock:(void (^)(NSArray<MSEWeather *> *forcast))success failureBlock:(void (^)(NSError *error))failure;

@end
