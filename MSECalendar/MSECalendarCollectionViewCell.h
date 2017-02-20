//
//  MSECalendarCollectionViewCell.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/1/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSECalendarBaseCollectionViewCell.h"

@interface MSECalendarCollectionViewCell : MSECalendarBaseCollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *monthLabel;
@property (nonatomic, weak) UIImageView *circleImageView;
@property (nonatomic, weak) IBOutlet UILabel *yearLabel;
@property (nonatomic, weak) IBOutlet UIImageView *highlightImageView;

@end
