//
//  MSEAgendaHeaderFooterView.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/7/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSEWeather;
@class MSEDate;

@interface MSEAgendaHeaderFooterView : UITableViewHeaderFooterView

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

- (void)initWithDate:(MSEDate *)date weather:(MSEWeather *)weather;

@end
