//
//  UICollectionView+MSECalendar.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/20/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "UICollectionView+MSECalendar.h"

@implementation UICollectionView (MSECalendar)

- (void)registerNibForCellFromClass:(Class)class {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(class)];
}

@end
