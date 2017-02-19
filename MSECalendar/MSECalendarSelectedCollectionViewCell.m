//
//  MSECalendarSelectedCollectionViewCell.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/8/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSECalendarSelectedCollectionViewCell.h"  
#import "UIColor+MSEColor.h"

@interface MSECalendarSelectedCollectionViewCell()

@property (nonatomic, weak) IBOutlet UIView *colorView;

@end

@implementation MSECalendarSelectedCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.colorView setBackgroundColor:[UIColor mseBlueColor]];
    self.colorView.layer.cornerRadius = self.colorView.frame.size.height/2;
}

@end
