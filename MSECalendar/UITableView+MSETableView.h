//
//  UITableView+MSETableView.h
//  MSECalendar
//
//  Created by Eric Harmon on 2/20/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (MSETableView)

- (void)registerNibForCellFromClass:(Class)class;
- (void)registerNibForHeaderFooterFromClass:(Class)class;

@end
