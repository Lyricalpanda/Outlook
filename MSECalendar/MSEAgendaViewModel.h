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

@interface MSEAgendaViewModel : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<MSEAgendaProtocol> delegate;

- (void) loadAgendaFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

@end
