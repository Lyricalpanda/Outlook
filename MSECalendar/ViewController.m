//
//  ViewController.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/1/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "UIColor+MSEColor.h"

#import "ViewController.h"
#import "MSECalendarUtils.h"
#import "MSECalendarCollectionViewCell.h"
#import "MSECalendarSelectedCollectionViewCell.h"
#import "MSECalendarView.h"
#import "MSEAgendaView.h"
#import "MSEMonth.h"
#import "MSEAgendaProtocol.h"
#import "MSECalendarUtils.h"
#import "MSECalendarWeekdayView.h"

NSInteger const NUMBER_OF_WEEKS_TO_HOLD = 7;

@interface ViewController () <MSEAgendaProtocol, MSECalendarProtocol>

@property (nonatomic, strong) MSECalendarUtils *utils;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *weeks;

@property (nonatomic, weak) IBOutlet MSECalendarView *calendarViewModel;
@property (nonatomic, weak) IBOutlet MSEAgendaView *agendaViewModel;
@property (nonatomic, weak) IBOutlet MSECalendarWeekdayView *weekdayView;

@end

@implementation ViewController

- (void)dateScrolled:(NSString *)date {
    [self.calendarViewModel selectedDate:date];
}

- (void) calendarSelectedDate:(NSDate *)date {
    [self.agendaViewModel scrollAgendaToDate:date];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.weeks = [@[] mutableCopy];
    [self.agendaViewModel setDelegate:self];
    [self.calendarViewModel setDelegate:self];
    
    self.utils = [MSECalendarUtils new];
    
    self.title = @"February";
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor mseBlueColor]];
    
    [self initializeWeeksArray];
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

- (void) viewWillAppear:(BOOL)animated {
    NSDate *firstDate = [self.weeks objectAtIndex:0];
    NSDate *lastDate = [self.utils addDays:6 toDate:[self.weeks lastObject]];
    [self.agendaViewModel loadAgendaFromDate:firstDate toDate:lastDate];
    [self.calendarViewModel initWithStartingDate:[NSDate date]];
}


@end
