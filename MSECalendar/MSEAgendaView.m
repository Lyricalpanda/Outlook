//
//  MSEAgendaViewModel.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/7/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSEAgendaView.h"
#import "UITableView+MSETableView.h"
#import "MSEAgendaHeaderFooterView.h"
#import "MSEAgendaEventTableViewCell.h"
#import "MSEAgendaEmptyTableViewCell.h"
#import "MSECalendarUtils.h"
#import "MSEEventStore.h"
#import "MSEEvent.h"
#import "MSEDate.h"
#import "MSEWeatherStore.h"

@interface MSEAgendaView()

@property (nonatomic, strong) NSMutableDictionary *weather;
@property (nonatomic, strong) NSMutableDictionary *rows;
@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic, strong) NSDate *firstDate;
@property (nonatomic, strong) NSDate *lastDate;
@property (nonatomic, strong) NSDate *today;

@property (nonatomic, strong) MSECalendarUtils *utils;
@property (nonatomic) NSUInteger firstVisibleIndex;

@property (nonatomic) BOOL isScrolling;
@end

@implementation MSEAgendaView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self ) {
        [self initAgendaView];
        __weak typeof(self) weakSelf = self;
        [[MSEWeatherStore mainstore] fetchTenDayForcastWithSuccessBlock:^(NSArray<MSEWeather *> *forcast) {
            NSUInteger todaySection = [weakSelf.utils daysBetweenDate:weakSelf.firstDate andDate:[NSDate date]];
            for (NSInteger i = 0; i < [forcast count]; i++){
                [weakSelf.weather setObject:forcast[i] forKey:[NSNumber numberWithInteger:todaySection + i]];
            }
            [self.tableView reloadData];
        } failureBlock:^(NSError *error) {
            
        }];
    }
    return self;
}

- (void)initAgendaView {
    [self initializeTableView];
    [self setBackgroundColor:[UIColor orangeColor]];
    self.firstVisibleIndex = 0;
    self.utils = [MSECalendarUtils new];
    self.rows = [@{} mutableCopy];
    self.weather = [@{} mutableCopy];
}

- (void)initializeTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setBounces:NO];
    
    [self.tableView registerNibForCellFromClass:[MSEAgendaEmptyTableViewCell class]];
    [self.tableView registerNibForCellFromClass:[MSEAgendaEventTableViewCell class]];
    [self.tableView registerNibForHeaderFooterFrom:[MSEAgendaHeaderFooterView class]];
    [self addSubview:self.tableView];
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
        NSUInteger numberOfDays = [self.utils daysBetweenDate:fromDate andDate:toDate];
        for (NSInteger i = 0; i < numberOfDays; i++) {
            NSDate *date = [self.utils addDays:i toDate:self.firstDate];
            NSArray *events = [[MSEEventStore mainStore] eventsForDate:date];
            MSEDate *event = [[MSEDate alloc] initWithEvents:events andDate:date];
            [self.rows setObject:event forKey:[NSNumber numberWithInteger:i]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self scrollAgendaToDate:[NSDate date]];
        });
    });
    
//    [self.tableView reloadData];
//    NSUInteger todaySection = [self.utils daysBetweenDate:self.firstDate andDate:[NSDate date]];
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:todaySection] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.utils daysBetweenDate:self.firstDate andDate:self.lastDate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.rows objectForKey:[NSNumber numberWithInteger:section]]) {
        MSEDate *date = [self.rows objectForKey:[NSNumber numberWithInteger:section]];
        return [[date events] count] > 0 ? [[date events] count] : 1;
    }
    else {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self.rows removeObjectForKey:[NSNumber numberWithInteger:indexPath.section]];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    MSEAgendaEmptyTableViewCell *emptyCell = (MSEAgendaEmptyTableViewCell *)cell;
//    if (indexPath.row == 0) {
//        [emptyCell isEndingCell:NO];
//    }
//    else {
//        [emptyCell isEndingCell:YES];
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MSEDate *date = [self.rows objectForKey:[NSNumber numberWithInteger:indexPath.section]];
    if ([date.events count] == 0) {
        return [self emptyCellForTableView:tableView];
    }
    else {
        return [self eventCellForTableView:tableView indexPath:indexPath date:date];
    }
}

- (MSEAgendaEventTableViewCell *)eventCellForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath date:(MSEDate *)date {
    MSEAgendaEventTableViewCell *agendaCell = (MSEAgendaEventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSEAgendaEventTableViewCell class])];
    MSEEvent *event = date.events[indexPath.row];
    [agendaCell initWithEvent:event isEndingRow:(indexPath.row >= [[date events] count]-1)];
    return agendaCell;
}

- (MSEAgendaEmptyTableViewCell *)emptyCellForTableView:(UITableView *)tableView {
    MSEAgendaEmptyTableViewCell *emptyCell = (MSEAgendaEmptyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSEAgendaEmptyTableViewCell class])];
    return emptyCell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MSEAgendaHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MSEAgendaHeaderFooterView class])];
    NSDate *date = [self.utils addDays:section toDate:self.firstDate];
    if ([self.weather objectForKey:[NSNumber numberWithInteger:section]]) {
        MSEWeather *weather = [self.weather objectForKey:[NSNumber numberWithInteger:section]];
        [view initWithDate:[self.utils stringForDate:date] weather:weather];
    }
    else {
        [view initWithDate:[self.utils stringForDate:date] weather:nil];
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MSEDate *date = [self.rows objectForKey:[NSNumber numberWithInteger:indexPath.section]];
    
    if ([[date events] count]) {
        return 75.0;
    }
    else {
        return 45.0;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isScrolling = YES;
    NSLog(@"Begin dragging");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSArray* indexPaths = [self.tableView indexPathsForVisibleRows];
    NSArray* sortedIndexPaths = [indexPaths sortedArrayUsingSelector:@selector(compare:)];
    NSInteger section = [(NSIndexPath*)[sortedIndexPaths objectAtIndex:0] section];
    if ([self.delegate respondsToSelector:@selector(agendaScrolled)]) {
        [self.delegate agendaScrolled];
    }
    if (section != self.firstVisibleIndex) {
        if ([self.delegate respondsToSelector:@selector(dateScrolled:)]) {
            [self.delegate dateScrolled:[self.utils addDays:section toDate:self.firstDate]];
        }
        self.firstVisibleIndex = section;
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.isScrolling = NO;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isScrolling = NO;
    if ([self.delegate respondsToSelector:@selector(agendaFinishedScrolling)]) {
        [self.delegate agendaFinishedScrolling];
    }
}

@end
