//
//  MSENetworking.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/20/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSENetworkingClient.h"

NSString const * API_BASE = @"http://api.wunderground.com/api";
NSString const * API_KEY = @"e20a24a5161af676";
NSString const * API_FORECAST_PATH = @"forecast10day/q";

static MSENetworkingClient *mainClient;

@implementation MSENetworkingClient

+ (instancetype) mainClient {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainClient = [MSENetworkingClient new];
    });
    
    return mainClient;
}

- (void)queryTenDayForcastWithSuccessBlock:(void (^)(NSDictionary *results))success failureBlock:(void (^)(NSError *error))failure {
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/CA/San_Francisco.json", API_BASE,API_KEY,API_FORECAST_PATH]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ([error.description length] > 0) {
            failure(error);
        }
        else {
            NSError *error2;
            NSDictionary *resultsDict = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:&error2];
            success(resultsDict);
        }
    }];
    [task resume];

}

- (void)queryItunesForMovieWithString:(NSString *)string successBlock:(void (^)(NSDictionary *results))success failureBlock:(void (^)(NSError *error))failure {
    
}

@end
