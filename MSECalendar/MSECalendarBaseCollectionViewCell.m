//
//  MSECalendarBaseCollectionViewCell.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/18/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSECalendarBaseCollectionViewCell.h"
#import "UIColor+MSEColor.h"

@interface MSECalendarBaseCollectionViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (nonatomic, strong) UIView *seperatorView;

@end

@implementation MSECalendarBaseCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.seperatorView = [UIView new];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.borderView setBackgroundColor:[UIColor mseSeperatorColor]];
}

@end
