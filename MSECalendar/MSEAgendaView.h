//
//  MSEAgendaViewModel.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/7/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MSEAgendaProtocol.h"

@protocol MSEAgendaProtocol <NSObject>

@optional

- (void) agendaScrolled;
- (void) agendaFinishedScrolling;
- (void) dateScrolled:(NSDate *)date;
- (void) decrementedDate;
- (void) incrementedDate;

@end

@interface MSEAgendaView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<MSEAgendaProtocol> delegate;
@property (nonatomic, strong) UITableView *tableView;

- (void) loadAgendaFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (void) scrollAgendaToDate:(NSDate *)date;

@end
