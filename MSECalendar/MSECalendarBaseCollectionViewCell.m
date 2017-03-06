//
//  MSECalendarBaseCollectionViewCell.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/18/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSECalendarBaseCollectionViewCell.h"
#import "UIColor+MSEColor.h"
#import "MSECalendarUtils.h"
#import "MSEDate.h"

@interface MSECalendarBaseCollectionViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;

@end

@implementation MSECalendarBaseCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.borderView setBackgroundColor:[UIColor mseSeperatorColor]];
}

- (void)initWithDate:(MSEDate *)date {
    NSInteger day = date.day;
    NSInteger month = date.month;
    if (month % 2 == 0) {
        [self setBackgroundColor:[UIColor mseLightGrayBackgroundColor]];
    }
    else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }

    [self.dateNumberLabel setText:[NSString stringWithFormat:@"%ld", day]];
}

@end
