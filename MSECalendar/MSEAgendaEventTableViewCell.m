//
//  MSEAgendaEventTableViewCell.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/7/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSEAgendaEventTableViewCell.h"
#import "MSECalendarUtils.h"
#import "MSEEvent.h"
#import "UIColor+MSEColor.h"

@interface MSEAgendaEventTableViewCell()

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *durationLabel;
@property (nonatomic, weak) IBOutlet UIView *colorView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) UIView *seperatorView;
@end

@implementation MSEAgendaEventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.colorView.layer.cornerRadius = self.colorView.frame.size.height/2;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.seperatorView = [UIView new];
        [self.seperatorView setBackgroundColor:[UIColor mseSeperatorColor]];
        [self addSubview:self.seperatorView];
    }
    return self;
}

- (void) initWithEvent:(MSEEvent *)event isEndingRow:(BOOL)isEnd {
    [self.timeLabel setText:event.timeString];
    [self.durationLabel setText:event.lengthString];
    [self.nameLabel setText:event.name];
    UIColor *color;
    switch (event.color) {
        case Blue:
            color = [UIColor blueColor];
            break;
        case Red:
            color = [UIColor redColor];
            break;
        
        case Green:
            color = [UIColor greenColor];
            break;
            
        default:
            break;
    }
    [self.colorView setBackgroundColor:color];
    if (isEnd) {
        [self.seperatorView setFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
    }
    else {
        [self.seperatorView setFrame:CGRectMake(16, self.frame.size.height-1, self.frame.size.width, 1)];
    }
}

@end
