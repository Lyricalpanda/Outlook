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
#import "KSTCollectionViewPageHorizontalLayout.h"
#import "RDHCollectionViewGridLayout.h"

#import "MSEMonth.h"

NSInteger const NUMBER_OF_WEEKS_TO_HOLD = 7;

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger begin;
@property (nonatomic, assign) NSInteger numberOfDays;
@property (nonatomic) NSInteger currentMonth;
@property (nonatomic) NSInteger currentYear;
@property (nonatomic) CGFloat lastOffset;
@property (nonatomic, strong) NSMutableArray *months;
@property (nonatomic, strong) NSIndexPath *selectedDate;
@property (nonatomic, strong) NSIndexPath *previousSelectedDate;

@property (nonatomic, strong) NSMutableArray *weeks;

@property (nonatomic, strong) MSECalendarUtils *utils;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.utils = [MSECalendarUtils new];
    self.weeks = [@[] mutableCopy];
    self.currentMonth = 2;
    self.currentYear = 2017;
    self.lastOffset = 0;
    self.count = 1;
    self.numberOfDays = [self.utils numberOfDaysInMonth:self.currentMonth year:self.currentYear];
    self.begin = [self.utils firstDayInMonth:self.currentMonth year:self.currentYear] - 1;
    [self initCollectionView];
    
    
    [self initializeWeeksArray];
//    [self initMonthsArray];
    [self.collectionView reloadData];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.collectionView layoutIfNeeded];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
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

- (void)initMonthsArray {
    self.months = [@[] mutableCopy];
    for (int i = 1; i <= 3; i++) {
        MSEMonth *month = [MSEMonth new];
        month.month = i;
        month.year = 2017;
        [self.months addObject:month];
    }
}

- (void)initCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.itemSize =CGSizeMake(self.collectionView.frame.size.width/7, self.collectionView.frame.size.height/5);
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MSECalendarCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MSECalendarCollectionViewCell class])];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5*2+1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    MSECalendarCollectionViewCell *mseCell = (MSECalendarCollectionViewCell *) cell;
    NSDate *currentWeek = [self.weeks objectAtIndex:indexPath.section];
    NSDate *weekDay = [self.utils addDays:indexPath.row toDate:currentWeek];
    NSInteger month = [self.utils monthFromDate:weekDay];
    if (month % 2 == 0) {
        [mseCell setBackgroundColor:[UIColor grayColor]];
    }
    else {
        [mseCell setBackgroundColor:[UIColor whiteColor]];
    }
    NSInteger day = [self.utils dayFromDate:weekDay];
    if (day == 1) {
        [mseCell.monthLabel setText:[self.utils monthAbbreviationFromMonth:month]];
    }
    else {
        [mseCell.monthLabel setText:@""];
    }
    
    [mseCell.dateNumberLabel setText:[NSString stringWithFormat:@"%ld", day]];
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MSECalendarCollectionViewCell *cell = (MSECalendarCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MSECalendarCollectionViewCell class]) forIndexPath:indexPath];
    if (self.previousSelectedDate == self.selectedDate) {
        return;
    }
    self.previousSelectedDate = self.selectedDate;
    self.selectedDate = indexPath;
    if (self.previousSelectedDate){
    [collectionView reloadItemsAtIndexPaths:@[indexPath, self.previousSelectedDate]];
    }
    else {
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Cell for section and row: %ld %ld", indexPath.section, indexPath.row);
    
    MSECalendarCollectionViewCell *cell = (MSECalendarCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MSECalendarCollectionViewCell class]) forIndexPath:indexPath];
    if (indexPath.row == self.selectedDate.row && indexPath.section == self.selectedDate.section) {
        [cell dateSelected:YES];
    }
    else if (indexPath.row == self.previousSelectedDate.row && indexPath.section == self.previousSelectedDate.section) {
        [cell dateSelected:NO];
    }
//    NSDate *currentWeek = [self.weeks objectAtIndex:indexPath.section];
//    NSDate *weekDay = [self.utils addDays:indexPath.row toDate:currentWeek];
//    [cell.dateNumberLabel setText:[NSString stringWithFormat:@"%ld", [self.utils dayFromDate:weekDay]]];
//    MSEMonth *month = self.months[indexPath.section];
//    if (month.startingWeekDay - 1 > indexPath.row) {
////        [cell.dateNumberLabel setText:[NSString stringWithFormat:@"-%ld", indexPath.row+1]];
//        [cell.dateNumberLabel setText:@""];
//    }
//    else if ((month.numberOfDays + month.startingWeekDay - 1) > indexPath.row) {
//        [cell.dateNumberLabel setText:[NSString stringWithFormat:@"%ld",indexPath.row+1 - (month.startingWeekDay-1)]];
//    } else {
////        [cell.dateNumberLabel setText:[NSString stringWithFormat:@"+%ld", indexPath.row+1]];
//        [cell.dateNumberLabel setText:@""];
//    }
//    
//    [cell setBackgroundColor:[UIColor redColor]];
//    [cell dateSelected:YES];
    return cell;
}

- (MSEMonth *)getPreviousMonth:(MSEMonth *)currentMonth {
    MSEMonth *newMonth = [MSEMonth new];
    if (currentMonth.month == 1) {
        newMonth.month = 12;
        newMonth.year = currentMonth.year - 1;
    }
    else {
        newMonth.month = currentMonth.month - 1;
        newMonth.year = currentMonth.year;
    }
    
    return newMonth;
}

- (MSEMonth *)getNextMonth:(MSEMonth *)currentMonth {
    MSEMonth *newMonth = [MSEMonth new];
    if (currentMonth.month == 12) {
        newMonth.month = 1;
        newMonth.year = currentMonth.year + 1;
    }
    else {
        newMonth.month = currentMonth.month + 1;
        newMonth.year = currentMonth.year;
    }
    
    return newMonth;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
//    if (scrollView.contentOffset.x == self.collectionView.frame.size.width) {
//        return;
//    }
//    
//    MSEMonth *currentMonth;
//    MSEMonth *newMonth;
//    
//    for (MSEMonth *month in self.months) {
//        NSLog(@"Before Month: %ld %ld", month.month, month.year);
//    }
//
//    if (self.lastOffset > scrollView.contentOffset.x) {
//        currentMonth = self.months[0];
//        newMonth = [self getPreviousMonth:currentMonth];
//        [self.months removeLastObject];
//        [self.months insertObject:newMonth atIndex:0];
//    }
//    else {
//        currentMonth = self.months[2];
//        newMonth = [self getNextMonth:currentMonth];
//        [self.months removeObjectAtIndex:0];
//        [self.months addObject:newMonth];
//    }
//    
//    for (MSEMonth *month in self.months) {
//        NSLog(@"Month: %ld %ld", month.month, month.year);
//    }
//
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:1] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
//    [self.collectionView reloadData];
//    
//    self.lastOffset = scrollView.contentOffset.x;
//    [self.titleLabel setText:[NSString stringWithFormat:@"%@ %ld", [self.utils monthName:currentMonth.month], currentMonth.year]];
}



@end
