//
//  MSEAgendaHeaderFooterView.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/7/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSEAgendaHeaderFooterView.h"

@implementation MSEAgendaHeaderFooterView

-(void) awakeFromNib {
    [super awakeFromNib];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self.dateLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

@end
