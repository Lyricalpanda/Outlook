//
//  MSECalendarViewModel.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/6/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSECalendarView.h"
#import "MSECalendarCollectionViewCell.h"
#import "MSECalendarSelectedCollectionViewCell.h"
#import "MSECalendarUtils.h"
#import "MSEEventStore.h"
#import "MSEDateStore.h"
#import "UIColor+MSEColor.h"
#import "UICollectionView+MSECalendar.h"
#import "MSEDate.h"

NSInteger const NUMBER_OF_WEEKDAYS = 7;
NSInteger const NUMBER_OF_WEEKS_TO_SHOW = 5;

@interface MSECalendarView()

@property (nonatomic, strong) NSArray *weeks;
@property (nonatomic, strong) MSECalendarUtils *utils;
@property (nonatomic, strong) MSEDate *selectedDate;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) CGFloat cellHeight;
@property (nonatomic) BOOL isScrolling;

@end

@implementation MSECalendarView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initCalendarView];
    }
    return self;
}

- (void)initCalendarView {
    self.weeks = [@[] mutableCopy];
    self.utils = [MSECalendarUtils new];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self initCollectionView];
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    [self.collectionView registerNibForCellFromClass:[MSECalendarSelectedCollectionViewCell class]];
    [self.collectionView registerNibForCellFromClass:[MSECalendarCollectionViewCell class]];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setBounces:NO];

    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.collectionView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.cellHeight = self.frame.size.height/NUMBER_OF_WEEKS_TO_SHOW;
    });
}

- (void)initWithNumberOfPreviousWeeks:(NSInteger)previousWeeks futureWeeks:(NSInteger)futureWeeks {
    __weak typeof(self) weakSelf = self;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        weakSelf.weeks = [[MSEDateStore mainStore] weeklyDatesFor:previousWeeks to:futureWeeks];
        NSDate *currentWeek = [MSECalendarUtils firstDayOfWeekFromDate:[NSDate date]];
        weakSelf.selectedIndexPath = [NSIndexPath indexPathForRow:[MSECalendarUtils daysBetweenDate:currentWeek andDate:[NSDate date]] inSection:previousWeeks];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            [weakSelf selectedDate:[[MSEDateStore mainStore] dateForDate:[NSDate date]] shouldScroll:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
        });
    });
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.weeks count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return NUMBER_OF_WEEKDAYS;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    MSECalendarBaseCollectionViewCell *mseCell = (MSECalendarBaseCollectionViewCell *) cell;

    MSEDate *currentWeek = [self.weeks objectAtIndex:indexPath.section];
    MSEDate *weekDay = [[MSEDateStore mainStore] dateByAddingDays:indexPath.row to:currentWeek];
    [mseCell initWithDate:weekDay];
}

- (void)selectedDate:(MSEDate *)date {
    [self selectedDate:date shouldScroll:YES scrollPosition:UICollectionViewScrollPositionTop];
}

- (void)selectedDate:(MSEDate *)date shouldScroll:(BOOL)isScrolling scrollPosition:(UICollectionViewScrollPosition) position {
    if ([self.selectedDate.date isEqualToDate:date.date]) {
        return;
    }
    
    //Do some calculations since we're only storing each sunday to reduce memory footprint (instead of storing all days)
    
    NSDate *week = [MSECalendarUtils firstDayOfWeekFromDate:date.date];
    NSInteger row = [MSECalendarUtils daysBetweenDate:week andDate:date.date];
    MSEDate *beginningWeek = self.weeks[0];
    NSInteger section = [MSECalendarUtils weeksBetweenDate:beginningWeek.date toDate:week];
    NSIndexPath *newPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSIndexPath *oldPath = self.selectedIndexPath;
    self.selectedIndexPath = newPath;
    self.selectedDate = date;
    
    if (isScrolling){
        [self.collectionView scrollToItemAtIndexPath:self.selectedIndexPath atScrollPosition:position animated:NO];
    }
    
    if (oldPath && ![oldPath isEqual:newPath]) {
        [self.collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath, oldPath]];
    }
    else {
        [self.collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MSEDate *week = self.weeks[indexPath.section];
    MSEDate *weekDay = [[MSEDateStore mainStore] dateByAddingDays:indexPath.row to:week];
    [self selectedDate:weekDay shouldScroll:NO scrollPosition:0];
    if ([self.delegate respondsToSelector:@selector(calendarSelectedDate:)]) {
        [self.delegate calendarSelectedDate:weekDay];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (int)CGRectGetWidth(collectionView.frame)/NUMBER_OF_WEEKDAYS;;
    
    //Add padding to last cell in case screen is not fully divisible evenly by number of workdays
    if (indexPath.row == NUMBER_OF_WEEKDAYS - 1) {
        width = (CGRectGetWidth(collectionView.frame) - (width) * (NUMBER_OF_WEEKDAYS - 1));
    }
    
    return CGSizeMake(width, self.cellHeight);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    
    if (indexPath.row == self.selectedIndexPath.row && indexPath.section == self.selectedIndexPath.section) {
        cell = (MSECalendarSelectedCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MSECalendarSelectedCollectionViewCell class]) forIndexPath:indexPath];
    }
    else {
        cell = (MSECalendarCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MSECalendarCollectionViewCell class]) forIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark ScrollView delegate methods

//The fun part is that we need to be mindful if the scrollView is moving from the agendaView scrolling and hitting the selectedDate method, or if the user is scrolling. If the scrollView is being scrolled because the agendaView is moving then we don't want to trigger our delegate methods since that will cause a conflict between the two. So I'm checking to see if it's a user scroll or not first.

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isScrolling = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isScrolling && [self.delegate respondsToSelector:@selector(calendarScrolled)]) {
        [self.delegate calendarScrolled];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        self.isScrolling = NO;
        if ([self.delegate respondsToSelector:@selector(calendarFinishedScrolling)]) {
            [self.delegate calendarFinishedScrolling];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isScrolling = NO;
    if ([self.delegate respondsToSelector:@selector(calendarFinishedScrolling)]) {
        [self.delegate calendarFinishedScrolling];
    }
}

@end
