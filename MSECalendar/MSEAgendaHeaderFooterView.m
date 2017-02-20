//
//  MSEAgendaHeaderFooterView.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/7/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSEAgendaHeaderFooterView.h"
#import "UIColor+MSEColor.h"

@implementation MSEAgendaHeaderFooterView

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height-1, rect.size.width, 1)];
    [borderView setBackgroundColor:[UIColor mseSeperatorColor]];
    [self addSubview:borderView];
}

-(void) awakeFromNib {
    [super awakeFromNib];
    NSLog(@"awake from nib");
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.dateLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
