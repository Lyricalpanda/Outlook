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
#import "MSEEventStore.h"

NSInteger const NUMBER_OF_WEEKS_TO_HOLD = 7;

@interface ViewController () <MSEAgendaProtocol, MSECalendarProtocol>
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *agendaHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *agendaTopConstraint;

@property (nonatomic, strong) MSECalendarUtils *utils;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *weeks;

@property (nonatomic, weak) IBOutlet MSECalendarView *calendarViewModel;
@property (nonatomic, weak) IBOutlet MSEAgendaView *agendaViewModel;
@property (nonatomic, weak) IBOutlet MSECalendarWeekdayView *weekdayView;

@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) BOOL isScrolling;
@property (nonatomic, assign) BOOL isCalendarSmall;

@end

@implementation ViewController

- (void)dateScrolled:(NSString *)date {
    [self.calendarViewModel selectedDate:date];
}

- (void) agendaFinishedScrolling {
    self.isScrolling = NO;
}

- (void) calendarFinishedScrolling {
    self.isScrolling = NO;
}

- (void) agendaScrolled {
    if (!self.isScrolling) {
        self.isScrolling = YES;
        if (!self.isAnimating && !self.isCalendarSmall) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view layoutIfNeeded];
            NSInteger cellWidth = self.calendarViewModel.frame.size.width / 7;
            self.agendaTopConstraint.constant = -1 * cellWidth * 3;
                [UIView animateWithDuration:0.5 animations:^{
                    [self.view layoutIfNeeded];
                } completion:^(BOOL finished) {
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                [UIView animateWithDuration:1.0 delay:0 options:0 animations:^{
            //                    // Your animation code
            //                } completion:^(BOOL finished) {
            //                    // Your completion code
            //                }];
    //                });
                    if (finished) {
                    self.isCalendarSmall = YES;
                    self.agendaTopConstraint.constant = 0;
                    self.calendarHeightConstraint.constant = cellWidth * 2;
                    self.isAnimating = NO;
                    }
                }];
            });
        }
    }
}

- (void)calendarScrolled {
    if (!self.isScrolling) {
        self.isScrolling = YES;
        if (!self.isAnimating && self.isCalendarSmall) {
            [self.view layoutIfNeeded];
            self.agendaTopConstraint.constant = 0;
            NSInteger cellWidth = self.calendarViewModel.frame.size.width / 7;
            self.calendarHeightConstraint.constant = cellWidth * 5;
            [UIView animateWithDuration:0.5 animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.isAnimating = NO;
                self.isCalendarSmall = NO;
            }];
        }
    }
}

- (void) calendarSelectedDate:(NSDate *)date {
    [self.agendaViewModel scrollAgendaToDate:date];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSInteger cellWidth = self.calendarViewModel.frame.size.width / 7;
        self.calendarHeightConstraint.constant = cellWidth * 5;
        self.agendaTopConstraint.constant = 0;
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [MSEEventStore mainStore];
    self.isAnimating = YES;
    self.weeks = [@[] mutableCopy];
    [self.agendaViewModel setDelegate:self];
    [self.calendarViewModel setDelegate:self];
    
    self.utils = [MSECalendarUtils new];
    
    self.title = @"February";
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor mseBlueColor]];
    
    [self initializeWeeksArray];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isAnimating = NO;
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
    [super viewWillAppear:animated];
    NSDate *firstDate = [self.weeks objectAtIndex:0];
    NSDate *lastDate = [self.utils addDays:6 toDate:[self.weeks lastObject]];
    [self.agendaViewModel loadAgendaFromDate:firstDate toDate:lastDate];
    [self.calendarViewModel initWithStartingDate:[NSDate date]];
}


@end
