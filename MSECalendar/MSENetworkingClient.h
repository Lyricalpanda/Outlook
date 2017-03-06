//
//  MSENetworking.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/20/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSENetworkingClient : NSObject

+ (instancetype)mainClient;
- (void)queryTenDayForcastWithSuccessBlock:(void (^)(NSDictionary *results))success failureBlock:(void (^)(NSError *error))failure;

@end
