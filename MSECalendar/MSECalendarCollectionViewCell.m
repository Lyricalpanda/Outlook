//
//  MSECalendarCollectionViewCell.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/1/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSECalendarCollectionViewCell.h"
#import "UIColor+MSEColor.h"
#import "MSEDate.h"
#import "MSECalendarUtils.h"

@interface MSECalendarCollectionViewCell()

@property (nonatomic, weak) IBOutlet UIView *eventDotView;
@property (nonatomic, weak) IBOutlet UILabel *monthLabel;
@property (nonatomic, weak) IBOutlet UILabel *yearLabel;

@end

@implementation MSECalendarCollectionViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    [self.eventDotView setBackgroundColor:[UIColor mseSeperatorColor]];
    self.eventDotView.layer.cornerRadius = self.eventDotView.frame.size.height/2;
    [self.eventDotView setHidden:YES];
}

-(void)prepareForReuse {
    [self.eventDotView setHidden:YES];
    [self.monthLabel setText:@""];
    [self.yearLabel setText:@""];
}

- (void) initWithDate:(MSEDate *)date {
    [super initWithDate:date];
    if ([[date events] count] > 0) {
        [self.eventDotView setHidden:NO];
    }
    else {
        [self.eventDotView setHidden:YES];
    }
    
    if (date.day == 1) {
        [self.monthLabel setText:[date monthAbbreviation]];
    }
    else {
        [self.monthLabel setText:@""];
    }
    
}

@end
