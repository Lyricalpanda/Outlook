//
//  MSECalendarWeekdayView.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/17/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSECalendarWeekdayView.h"
#import "UIColor+MSEColor.h"

@interface MSECalendarWeekdayView()

@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *labels;

@end

@implementation MSECalendarWeekdayView

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        [self addSubview:self.view];
        [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view":self.view}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view":self.view}]];
        
        for (NSInteger i = 0; i < [self.labels count]; i++) {
            UILabel *label = self.labels[i];
            if (i == 0 || i == [self.labels count] - 1) {
                [label setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:14]];
            }
            else {
                [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
            }
            [label setTextColor:[UIColor whiteColor]];
        }
        [self setBackgroundColor:[UIColor mseBlueColor]];
        
    }
    return self;
}

@end
