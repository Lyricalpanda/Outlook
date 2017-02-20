//
//  MSEWeather.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/20/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSEWeather : NSObject

@property (nonatomic) NSInteger high;
@property (nonatomic) NSInteger low;
@property (nonatomic) NSString *imageURL;

- (instancetype) initWithDictionary:(NSDictionary *)dictionary;

@end
