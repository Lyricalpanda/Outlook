//
//  MSEAgendaViewModel.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/7/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MSEDate;

@protocol MSEAgendaProtocol <NSObject>

@optional

- (void) agendaScrolled:(MSEDate *)date;
- (void) agendaFinishedScrolling;
- (void) decrementedDate;
- (void) incrementedDate;

@end

@interface MSEAgendaView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<MSEAgendaProtocol> delegate;
@property (nonatomic, strong) UITableView *tableView;

- (void) initWithNumberOfPreviousWeeks:(NSInteger)previousWeeks futureWeeks:(NSInteger)futureWeeks;
- (void) scrollAgendaToDate:(MSEDate *)date;

@end
