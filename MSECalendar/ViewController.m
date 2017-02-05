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

#import "FullyHorizontalFlowLayout.h"

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


@property (nonatomic, strong) MSECalendarUtils *utils;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.utils = [MSECalendarUtils new];
    self.currentMonth = 2;
    self.currentYear = 2017;
    self.lastOffset = 0;
    self.count = 1;
    self.numberOfDays = [self.utils numberOfDaysInMonth:self.currentMonth year:self.currentYear];
    self.begin = [self.utils firstDayInMonth:self.currentMonth year:self.currentYear] - 1;
    [self initCollectionView];
    
    [self initMonthsArray];
    [self.collectionView reloadData];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.collectionView layoutIfNeeded];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:1] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
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
    
    FullyHorizontalFlowLayout *flowLayout = [FullyHorizontalFlowLayout new];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.itemSize =CGSizeMake(self.collectionView.frame.size.width/7, self.collectionView.frame.size.height/6);
    flowLayout.nbColumns = 7;
    flowLayout.nbLines = 6;
    
    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MSECalendarCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MSECalendarCollectionViewCell class])];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.months count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 42;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MSECalendarCollectionViewCell *cell = (MSECalendarCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MSECalendarCollectionViewCell class]) forIndexPath:indexPath];
    MSEMonth *month = self.months[indexPath.section];
    if (month.startingWeekDay - 1 > indexPath.row) {
//        [cell.dateNumberLabel setText:[NSString stringWithFormat:@"-%ld", indexPath.row+1]];
        [cell.dateNumberLabel setText:@""];
    }
    else if ((month.numberOfDays + month.startingWeekDay - 1) > indexPath.row) {
        [cell.dateNumberLabel setText:[NSString stringWithFormat:@"%ld",indexPath.row+1 - (month.startingWeekDay-1)]];
    } else {
//        [cell.dateNumberLabel setText:[NSString stringWithFormat:@"+%ld", indexPath.row+1]];
        [cell.dateNumberLabel setText:@""];
    }
    
    [cell setBackgroundColor:[UIColor redColor]];
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
    
    if (scrollView.contentOffset.x == self.collectionView.frame.size.width) {
        return;
    }
    
    MSEMonth *currentMonth;
    MSEMonth *newMonth;
    
    for (MSEMonth *month in self.months) {
        NSLog(@"Before Month: %ld %ld", month.month, month.year);
    }

    if (self.lastOffset > scrollView.contentOffset.x) {
        currentMonth = self.months[0];
        newMonth = [self getPreviousMonth:currentMonth];
        [self.months removeLastObject];
        [self.months insertObject:newMonth atIndex:0];
    }
    else {
        currentMonth = self.months[2];
        newMonth = [self getNextMonth:currentMonth];
        [self.months removeObjectAtIndex:0];
        [self.months addObject:newMonth];
    }
    
    for (MSEMonth *month in self.months) {
        NSLog(@"Month: %ld %ld", month.month, month.year);
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:1] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    [self.collectionView reloadData];
    
    self.lastOffset = scrollView.contentOffset.x;
    [self.titleLabel setText:[NSString stringWithFormat:@"%@ %ld", [self.utils monthName:currentMonth.month], currentMonth.year]];
}



@end
