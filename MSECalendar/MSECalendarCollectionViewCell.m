//
//  MSECalendarCollectionViewCell.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/1/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSECalendarCollectionViewCell.h"

@interface MSECalendarCollectionViewCell()


@end

@implementation MSECalendarCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self.highlightImageView setHidden:YES];
}

- (void)prepareForReuse {
//    [self.highlightImageView setHidden:YES];
//    [self.monthLabel setHidden:NO];
//    [self.yearLabel setHidden:NO];
//    [self.circleImageView setHidden:NO];
//    self.monthLabel.text = @"";
//    self.yearLabel.text = @"";
//    self.circleImageView.image = nil;
//    
}

- (void)dateSelected:(BOOL)isSelected {
    if (isSelected) {
        __weak MSECalendarCollectionViewCell *weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageNamed:@"selected_circle"];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.highlightImageView.image = image;
            });
        });
        [self.highlightImageView setHidden:NO];
        [self.monthLabel setHidden:YES];
        [self.yearLabel setHidden:YES];
        [self.circleImageView setHidden:YES];
    }
    else {
        [self.highlightImageView setHidden:YES];
        self.highlightImageView.image = nil;
        [self.monthLabel setHidden:NO];
        [self.yearLabel setHidden:NO];
        [self.circleImageView setHidden:NO];
    }
}

@end
