//
//  UIColor+MSEColor.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/18/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "UIColor+MSEColor.h"

@implementation UIColor (MSEColor)

#define COLOR_FACTORY(name, redColor, greenColor, blueColor) + (instancetype)name { \
static UIColor *color; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
color = [UIColor colorWithRed:(redColor)/255.0 green:(greenColor)/255.0 blue:(blueColor)/255.0 alpha:1.0]; \
}); \
return color; \
} \

COLOR_FACTORY(mseBlueColor, 19, 122, 212)
COLOR_FACTORY(mseLightBlueColor, 245, 250, 252)
COLOR_FACTORY(mseSeperatorColor, 223, 223, 223)
COLOR_FACTORY(mseLightGrayBackgroundColor, 248, 248, 248)
COLOR_FACTORY(mseLightGrayColor, 135, 135, 140)

@end
