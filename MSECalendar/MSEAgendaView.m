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
#import "MSEDateStore.h"

@interface MSEAgendaView()

@property (nonatomic, strong) UIView *shadowView;
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
    }
    return self;
}

- (void)initAgendaView {
    [self initializeTableView];
    [self initializeShadowView];
    [self setBackgroundColor:[UIColor orangeColor]];
    self.firstVisibleIndex = 0;
    self.utils = [MSECalendarUtils new];
    self.rows = [@{} mutableCopy];
    self.weather = [@{} mutableCopy];
}

- (void)initializeShadowView {
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 2)];
    [self.shadowView setBackgroundColor:[UIColor blackColor]];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.shadowView.bounds;
    gradient.colors = @[(id)[UIColor blackColor].CGColor, (id)[UIColor whiteColor].CGColor];
    
    [self.shadowView.layer insertSublayer:gradient atIndex:0];
    [self addSubview:self.shadowView];
}

- (void)initializeTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setBounces:NO];
    
    [self.tableView registerNibForCellFromClass:[MSEAgendaEmptyTableViewCell class]];
    [self.tableView registerNibForCellFromClass:[MSEAgendaEventTableViewCell class]];
    [self.tableView registerNibForHeaderFooterFromClass:[MSEAgendaHeaderFooterView class]];
    [self addSubview:self.tableView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.tableView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

- (void)scrollAgendaToDate:(MSEDate *)date {
    NSUInteger todaySection = [MSECalendarUtils daysBetweenDate:self.firstDate andDate:date.date];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:todaySection] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

//This method inits the agenda based on how many previous and future weeks. The current implementation
//only stores days that have an event in a hashmap. Since some days are likely to not have events, this seemed like the most efficient
//use of space. Any days that do not have an event are not saved and can be dealt with in the tableView methods pretty eaisly.
//If I had more time I would do something with removing days that belonged to cells that were being dequeued
//to save more memory.

- (void)initWithNumberOfPreviousWeeks:(NSInteger)previousWeeks futureWeeks:(NSInteger)futureWeeks {
    NSDate *currentWeek = [MSECalendarUtils firstDayOfWeekFromDate:[NSDate date]];
    self.firstDate = [MSECalendarUtils addDays:-1*7*previousWeeks toDate:currentWeek];
    self.lastDate = [MSECalendarUtils addDays:1*7*futureWeeks toDate:currentWeek];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
        NSUInteger numberOfDays = [MSECalendarUtils daysBetweenDate:weakSelf.firstDate andDate:weakSelf.lastDate];
        for (NSInteger i = 0; i < numberOfDays; i++) {
            NSDate *date = [MSECalendarUtils addDays:i toDate:weakSelf.firstDate];
            NSArray *events = [[MSEEventStore mainStore] eventsForDate:date];
            MSEDate *event = [[MSEDate alloc] initWithEvents:events andDate:date];
            //only store rows that have events. Otherwise no need to store them.
            if ([[event events] count] > 0) {
                [weakSelf.rows setObject:event forKey:[NSNumber numberWithInteger:i]];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [weakSelf scrollAgendaToDate:[[MSEDateStore mainStore] dateForDate:[NSDate date]]];
        });
    });
    
    //While we're generating the Agenda also fetch 10 day forecast and put it on today + next 9 days
    [[MSEWeatherStore mainstore] fetchTenDayForcastWithSuccessBlock:^(NSArray<MSEWeather *> *forcast) {
        NSUInteger todaySection = [MSECalendarUtils daysBetweenDate:weakSelf.firstDate andDate:[NSDate date]];
        for (NSInteger i = 0; i < [forcast count]; i++){
            [weakSelf.weather setObject:forcast[i] forKey:[NSNumber numberWithInteger:todaySection + i]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } failureBlock:^(NSError *error) {
        
    }];

}

#pragma mark - UITableView Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [MSECalendarUtils daysBetweenDate:self.firstDate andDate:self.lastDate];
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
    NSDate *date = [MSECalendarUtils addDays:section toDate:self.firstDate];
    MSEDate *mseDate = [[MSEDateStore mainStore] dateForDate:date];
    [view initWithDate:mseDate weather:[self.weather objectForKey:[NSNumber numberWithInteger:section]]];
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
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSArray* indexPaths = [self.tableView indexPathsForVisibleRows];
    NSArray* sortedIndexPaths = [indexPaths sortedArrayUsingSelector:@selector(compare:)];
    NSInteger section = [(NSIndexPath*)[sortedIndexPaths objectAtIndex:0] section];
    if (self.isScrolling) {
        if ([self.delegate respondsToSelector:@selector(agendaScrolled:)]) {
            [self.delegate agendaScrolled:[[MSEDateStore mainStore] dateForDate:[MSECalendarUtils addDays:section toDate:self.firstDate]]];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate){
        self.isScrolling = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isScrolling = NO;
    if ([self.delegate respondsToSelector:@selector(agendaFinishedScrolling)]) {
        [self.delegate agendaFinishedScrolling];
    }
}

@end
