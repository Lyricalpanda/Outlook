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

@interface MSEAgendaView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<MSEAgendaProtocol> delegate;
@property (nonatomic, strong) UITableView *tableView;

- (void) loadAgendaFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (void) scrollAgendaToDate:(NSDate *)date;

@end
