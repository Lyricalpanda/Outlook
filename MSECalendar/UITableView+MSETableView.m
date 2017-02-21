//
//  UITableView+MSETableView.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/20/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "UITableView+MSETableView.h"

@implementation UITableView (MSETableView)

- (void)registerNibForCellFromClass:(Class)class {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(class)];
}
- (void)registerNibForHeaderFooterFromClass:(Class)class {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(class) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass(class)];
}

@end
