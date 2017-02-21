//
//  MSECalendarViewModel.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/6/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MSEDate;

@protocol MSECalendarProtocol <NSObject>

@optional

- (void)calendarSelectedDate:(MSEDate *)date;
- (void)calendarScrolled;
- (void)calendarFinishedScrolling;

@end

@interface MSECalendarView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) id<MSECalendarProtocol> delegate;

- (void)initWithNumberOfPreviousWeeks:(NSInteger)previousWeeks futureWeeks:(NSInteger)futureWeeks;
- (void)selectedDate:(MSEDate *)date;
@end
