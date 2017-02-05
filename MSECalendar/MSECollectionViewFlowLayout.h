//
//  MSECollectionViewFlowLayout.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/1/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSECollectionViewFlowLayout : UICollectionViewLayout


@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) CGFloat interitemSpacing;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) CGFloat sectionInsetTop;
@property (nonatomic, assign) NSInteger columnCount; // 分成多少列，默认为0。如不设置，则会通过itemSize去计算

@end
