//
//  MSECalendarSelectedCollectionViewCell.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/8/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSECalendarSelectedCollectionViewCell.h"

@interface MSECalendarSelectedCollectionViewCell()

@property (nonatomic, weak) IBOutlet UIView *colorView;

@end

@implementation MSECalendarSelectedCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.backgroundColor
    [self.colorView setBackgroundColor:[UIColor blueColor]];
    self.colorView.layer.cornerRadius = self.frame.size.height;
    // Initialization code
}

@end
