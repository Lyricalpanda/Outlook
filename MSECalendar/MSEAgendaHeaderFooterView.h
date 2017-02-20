//
//  MSEAgendaHeaderFooterView.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/7/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSEWeather;

@interface MSEAgendaHeaderFooterView : UITableViewHeaderFooterView

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

- (void)initWithDate:(NSString *)date weather:(MSEWeather *)weather;

@end
