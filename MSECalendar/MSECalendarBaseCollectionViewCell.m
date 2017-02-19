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

@end

@implementation MSECalendarBaseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.borderView setBackgroundColor:[UIColor mseSeperatorColor]];
    
    UIScreen* mainScreen = [UIScreen mainScreen];
    CGFloat onePixel = 1.0 / mainScreen.scale;
    if ([mainScreen respondsToSelector:@selector(nativeScale)])
        onePixel = 1.0 / mainScreen.nativeScale;
    [self.height setConstant:onePixel];

}

@end
