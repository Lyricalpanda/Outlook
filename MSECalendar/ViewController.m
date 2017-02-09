//
//  ViewController.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/1/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "ViewController.h"
#import "MSECalendarUtils.h"
#import "MSECalendarCollectionViewCell.h"
#import "MSECalendarSelectedCollectionViewCell.h"
#import "MSECalendarViewModel.h"
#import "MSEAgendaViewModel.h"
#import "MSEMonth.h"
#import "MSEAgendaProtocol.h"
#import "MSECalendarUtils.h"

NSInteger const NUMBER_OF_WEEKS_TO_HOLD = 7;

@interface ViewController () <MSEAgendaProtocol>

@property (nonatomic, strong) MSECalendarUtils *utils;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *weeks;

@property (nonatomic, weak) IBOutlet MSECalendarViewModel *calendarViewModel;
@property (nonatomic, weak) IBOutlet MSEAgendaViewModel *agendaViewModel;

@end

@implementation ViewController

- (void)dateScrolled:(NSString *)date {
    NSLog(@"Date : %@", date);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.weeks = [@[] mutableCopy];
    
//    self.calendarViewModel = [MSECalendarViewModel new];
    [self.agendaViewModel setDelegate:self];
    self.utils = [MSECalendarUtils new];
//    self.agendaViewModel = [MSEAgendaViewModel new];
    
    [self initializeWeeksArray];
//    [self initTableView];
//    [self.agendaViewModel setBackgroundColor:[UIColor redColor]];
//    [self.collectionView reloadData];
}

- (void)initializeWeeksArray {
    NSDate *currentWeek = [self.utils firstDayOfWeekFromDate:[NSDate date]];
    NSDate *previousWeek = [currentWeek copy];
    NSDate *nextWeek = [currentWeek copy];
    [self.weeks addObject:currentWeek];
    for (int i = 0; i < 5; i++) {
        previousWeek = [self.utils previousWeekFromDate:previousWeek];
        [self.weeks insertObject:previousWeek atIndex:0];
    }
    for (int i = 0; i < 5; i++) {
        nextWeek = [self.utils nextWeekFromDate:nextWeek];
        [self.weeks addObject:nextWeek];
    }
}

- (void) incrementedDate {
    [self.calendarViewModel incrementDate];
}

- (void) decrementedDate {
    [self.calendarViewModel decrementDate];
}

- (void) viewWillAppear:(BOOL)animated {
    NSDate *firstDate = [self.weeks objectAtIndex:0];
    NSDate *lastDate = [self.utils addDays:6 toDate:[self.weeks lastObject]];
    [self.agendaViewModel loadAgendaFromDate:firstDate toDate:lastDate];
    [self.calendarViewModel initWithStartingDate:[NSDate date]];
}


@end
