//
//  MSECalendarBaseCollectionViewCell.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/18/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSECalendarBaseCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIView *borderView;
@property (nonatomic, weak) IBOutlet UILabel *dateNumberLabel;

@end
