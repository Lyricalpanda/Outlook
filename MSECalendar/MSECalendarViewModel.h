//
//  MSECalendarViewModel.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/6/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MSECalendarViewModel : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

- (void) initWithStartingDate:(NSDate *)date;
- (void) incrementDate;
- (void) decrementDate;

@end
