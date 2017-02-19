//
//  MSEAgendaViewModel.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/7/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSEAgendaView.h"
#import "MSEAgendaHeaderFooterView.h"
#import "MSEAgendaEventTableViewCell.h"
#import "MSEAgendaEmptyTableViewCell.h"
#import "MSECalendarUtils.h"

@interface MSEAgendaView()

@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic, strong) NSDate *firstDate;
@property (nonatomic, strong) NSDate *lastDate;
@property (nonatomic, strong) NSDate *today;

@property (nonatomic, strong) MSECalendarUtils *utils;
@property (nonatomic) NSUInteger firstVisibleIndex;

@end

@implementation MSEAgendaView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self ) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MSEAgendaEmptyTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MSEAgendaEmptyTableViewCell class])];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MSEAgendaEventTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MSEAgendaEventTableViewCell class])];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MSEAgendaHeaderFooterView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MSEAgendaHeaderFooterView class])];
        [self addSubview:self.tableView];
        [self setBackgroundColor:[UIColor orangeColor]];
        self.firstVisibleIndex = 0;
        self.utils = [MSECalendarUtils new];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.tableView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

- (void) scrollAgendaToDate:(NSDate *)date {
    NSUInteger todaySection = [self.utils daysBetweenDate:self.firstDate andDate:date];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:todaySection] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void) loadAgendaFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    self.firstDate = [fromDate copy];;
    self.lastDate = [toDate copy];
    [self.tableView reloadData];
    NSUInteger todaySection = [self.utils daysBetweenDate:self.firstDate andDate:[NSDate date]];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:todaySection] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.utils daysBetweenDate:self.firstDate andDate:self.lastDate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MSEAgendaEmptyTableViewCell *emptyCell = (MSEAgendaEmptyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSEAgendaEmptyTableViewCell class])];
    [emptyCell setBackgroundColor:[UIColor redColor]];
    return emptyCell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MSEAgendaHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MSEAgendaHeaderFooterView class])];
    NSDate *date = [self.utils addDays:section toDate:self.firstDate];
    [view.dateLabel setText:[self.utils stringForDate:date]];
    [view.contentView setBackgroundColor:[UIColor whiteColor]];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSArray* indexPaths = [self.tableView indexPathsForVisibleRows];
    NSArray* sortedIndexPaths = [indexPaths sortedArrayUsingSelector:@selector(compare:)];
    NSInteger section = [(NSIndexPath*)[sortedIndexPaths objectAtIndex:0] section];
    if (section != self.firstVisibleIndex) {
        if ([self.delegate respondsToSelector:@selector(dateScrolled:)]) {
            [self.delegate dateScrolled:[self.utils addDays:section toDate:self.firstDate]];
        }
        self.firstVisibleIndex = section;
    }
}

@end
