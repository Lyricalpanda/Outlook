//
//  MSECalendarViewModel.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/6/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MSECalendarProtocol <NSObject>

@optional

- (void) calendarSelectedDate:(NSDate *)date;
- (void) calendarScrolled;
- (void) calendarFinishedScrolling;

@end

@interface MSECalendarView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) id<MSECalendarProtocol> delegate;

- (void) initWithStartingDate:(NSDate *)date;
- (void) selectedDate:(NSDate *)date;
@end
