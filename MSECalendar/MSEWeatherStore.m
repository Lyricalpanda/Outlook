//
//  MSEWeatherStore.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/20/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSEWeatherStore.h"
#import "MSEWeather.h"
#import "MSENetworkingClient.h"

static MSEWeatherStore *mainstore;

@implementation MSEWeatherStore

+ (instancetype) mainstore {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainstore = [MSEWeatherStore new];
    });
    
    return mainstore;
}

- (void) fetchTenDayForcastWithSuccessBlock:(void (^)(NSArray<MSEWeather *> *forcast))success failureBlock:(void (^)(NSError *error))failure{
    [[MSENetworkingClient mainClient] queryTenDayForcastWithSuccessBlock:^(NSDictionary *results) {
        NSMutableArray * weatherArray = [@[] mutableCopy];
        NSDictionary *forecast = [results objectForKey:@"forecast"];
        NSDictionary *simpleForecast = [forecast objectForKey:@"simpleforecast"];
        NSArray *dayForecast = [simpleForecast objectForKey:@"forecastday"];
        for (NSDictionary *dateForcast in dayForecast) {
            MSEWeather *weather = [[MSEWeather alloc] initWithDictionary:dateForcast];
            [weatherArray addObject:weather];
        }
        success(weatherArray);
    } failureBlock:^(NSError *error) {
        failure(error);
    }];
}
@end
