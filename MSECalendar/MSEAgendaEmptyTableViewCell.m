//
//  MSEAgendaEmptyTableViewCell.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/7/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSEAgendaEmptyTableViewCell.h"
#import "UIColor+MSEColor.h"

@interface MSEAgendaEmptyTableViewCell()

@property (nonatomic, strong) UIView *seperatorView;

@end

@implementation MSEAgendaEmptyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.seperatorView setBackgroundColor:[UIColor mseSeperatorColor]];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.seperatorView = [UIView new];
        [self addSubview:self.seperatorView];
    }
    return self;
}

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self.seperatorView setFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
}

@end
