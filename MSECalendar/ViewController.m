//
//  ViewController.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/1/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "UIColor+MSEColor.h"

#import "ViewController.h"
#import "MSECalendarCollectionViewCell.h"
#import "MSECalendarSelectedCollectionViewCell.h"
#import "MSECalendarView.h"
#import "MSEAgendaView.h"
#import "MSECalendarWeekdayView.h"
#import "MSEEventStore.h"
#import "MSEDate.h"

NSInteger const NUMBER_OF_WEEKS_TO_HOLD = 7;

@interface ViewController () <MSEAgendaProtocol, MSECalendarProtocol>
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *agendaHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *agendaTopConstraint;

@property (nonatomic, weak) IBOutlet MSECalendarView *calendarViewModel;
@property (nonatomic, weak) IBOutlet MSEAgendaView *agendaViewModel;
@property (nonatomic, weak) IBOutlet MSECalendarWeekdayView *weekdayView;

@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) BOOL isScrolling;
@property (nonatomic, assign) BOOL isCalendarSmall;

@end

@implementation ViewController

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
    [self.agendaViewModel setDelegate:self];
    [self.calendarViewModel setDelegate:self];
    
    self.title = @"February";
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor mseBlueColor]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isAnimating = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.agendaViewModel initWithNumberOfPreviousWeeks:12 futureWeeks:12];
    [self.calendarViewModel initWithNumberOfPreviousWeeks:12 futureWeeks:12];
}

#pragma mark MSEAgendaViewModel Delegate Methods

- (void)agendaFinishedScrolling {
    self.isScrolling = NO;
}

- (void) agendaScrolled {
    //If one of the two views are scrolling, then block the GUI. I noticed in the Android Outlook that you can get a weird UX if you scroll both the agenda and calendar at the same time, since they're both trying to manipulate the view. I want to make sure first and foremost we are not scrolling.
    if (!self.isScrolling) {
        self.isScrolling = YES;
        //If we're not scrolling, double check to make sure we're not animating and the calendar is full sized. Otherwise, we shouldn't be animating the calendar to grow
        if (!self.isAnimating && !self.isCalendarSmall) {
            //Added this since I was getting an animation bug with the constraints firing immediately.
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.view layoutIfNeeded];
                NSInteger cellWidth = self.calendarViewModel.frame.size.width / 7;
                self.agendaTopConstraint.constant = -1 * cellWidth * 3;
                [UIView animateWithDuration:0.5 animations:^{
                    [self.view layoutIfNeeded];
                } completion:^(BOOL finished) {
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

- (void)dateScrolled:(MSEDate *)date {
    self.title = [date monthName];
    [self.calendarViewModel selectedDate:date];
}

#pragma mark MSECalendarViewModel Delegate Methods

- (void)calendarFinishedScrolling {
    self.isScrolling = NO;
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

- (void)calendarSelectedDate:(MSEDate *)date {
    self.title = [date monthName];
    [self.agendaViewModel scrollAgendaToDate:date];
}

@end
