//
//  MSEAgendaEventTableViewCell.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/7/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSEEvent;

@interface MSEAgendaEventTableViewCell : UITableViewCell

- (void) initWithEvent:(MSEEvent *)event isEndingRow:(BOOL)isEnd;

@end
