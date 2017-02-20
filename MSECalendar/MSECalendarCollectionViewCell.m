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
    
    MSECalendarUtils *utils = [MSECalendarUtils new];
    NSInteger day = [utils dayFromDate:[date date]];
    NSInteger month = [utils monthFromDate:[date date]];

    if (day == 1) {
        [self.monthLabel setText:[utils monthAbbreviationFromMonth:month]];
    }
    else {
        [self.monthLabel setText:@""];
    }
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}


@end
