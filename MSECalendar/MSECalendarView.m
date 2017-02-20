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
#import "MSEMonth.h"
#import "UIColor+MSEColor.h"
#import "MSEEventStore.h"
#import "UICollectionView+MSECalendar.h"
#import "MSEDate.h"

@interface MSECalendarView()

@property (nonatomic, strong) NSMutableArray *weeks;
@property (nonatomic, strong) MSECalendarUtils *utils;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat cellHeight;

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

- (void) initCalendarView {
    self.weeks = [@[] mutableCopy];
    self.utils = [MSECalendarUtils new];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self initCollectionView];
    [self initializeWeeksArray];
}

- (void) initCollectionView{
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

- (void) layoutSubviews {
    [super layoutSubviews];
    [self.collectionView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.cellHeight = self.frame.size.height/5;
    });

}

- (void) initWithStartingDate:(NSDate *)date {
    [self.collectionView reloadData];
}

- (void)initializeWeeksArray {
    NSDate *currentWeek = [self.utils firstDayOfWeekFromDate:[NSDate date]];
    NSDate *previousWeek = [currentWeek copy];
    NSDate *nextWeek = [currentWeek copy];
    for (int i = 0; i < 5; i++) {
        previousWeek = [self.utils previousWeekFromDate:previousWeek];
        [self.weeks insertObject:previousWeek atIndex:0];
    }
    self.selectedIndexPath = [NSIndexPath indexPathForRow:[self.utils daysBetweenDate:currentWeek andDate:[NSDate date]] inSection:[self.weeks count]];
    self.selectedDate = [NSDate date];
    
    [self.weeks addObject:currentWeek];
    for (int i = 0; i < 5; i++) {
        nextWeek = [self.utils nextWeekFromDate:nextWeek];
        [self.weeks addObject:nextWeek];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 5*2+1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *currentWeek = [self.weeks objectAtIndex:indexPath.section];
    NSDate *weekDay = [self.utils addDays:indexPath.row toDate:currentWeek];
    NSInteger month = [self.utils monthFromDate:weekDay];
    if (month % 2 == 0) {
        [cell setBackgroundColor:[UIColor mseLightGrayBackgroundColor]];
    }
    else {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }

    MSECalendarBaseCollectionViewCell *mseCell = (MSECalendarBaseCollectionViewCell *) cell;
    MSEDate *date = [[MSEDate alloc] initWithEvents:[[MSEEventStore mainStore] eventsForDate:weekDay] andDate:weekDay];
    [mseCell initWithDate:date];
    
//    NSInteger day = [self.utils dayFromDate:weekDay];
//    if (![cell isKindOfClass:[MSECalendarSelectedCollectionViewCell class]]) {
//        if (day == 1) {
//            [((MSECalendarCollectionViewCell * )mseCell).monthLabel setText:[self.utils monthAbbreviationFromMonth:month]];
//        }
//        else {
//            [((MSECalendarCollectionViewCell * )mseCell).monthLabel setText:@""];
//        }
//        
//    }
//    NSArray *events = [[MSEEventStore mainStore] eventsForDate:weekDay];
//    [mseCell.dateNumberLabel setText:[NSString stringWithFormat:@"%ld", day]];
}

- (void) selectedDate:(NSDate *)date {
    [self selectedDate:date shouldScroll:YES];
}

- (void) selectedDate:(NSDate *)date shouldScroll:(BOOL)isScrolling{
    if ([self.selectedDate isEqualToDate:date]) {
        return;
    }
    NSDate *week = [self.utils firstDayOfWeekFromDate:date];
    NSInteger row = [self.utils daysBetweenDate:week andDate:date];
    NSInteger section = [self.utils weeksBetweenDate:self.weeks[0] toDate:week];
    NSIndexPath *newPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSIndexPath *oldPath = self.selectedIndexPath;
    self.selectedIndexPath = newPath;
    self.selectedDate = date;
    
    if (isScrolling){
        [self.collectionView scrollToItemAtIndexPath:self.selectedIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }
    
    if (oldPath) {
        [self.collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath, oldPath]];
    }
    else {
        [self.collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndexPath == indexPath) {
        return;
    }

    [self selectedDate:[self.utils addDays:indexPath.row toDate:[self.weeks objectAtIndex:indexPath.section]] shouldScroll:NO];
    if ([self.delegate respondsToSelector:@selector(calendarSelectedDate:)]) {
        [self.delegate calendarSelectedDate:self.selectedDate];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (int)CGRectGetWidth(collectionView.frame)/7;
    
    if (indexPath.row < 6) {
    }
    else {
        width = (CGRectGetWidth(collectionView.frame) - (width) * 6);
    }
    
    return CGSizeMake(width, self.cellHeight);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    
    if (indexPath.row == self.selectedIndexPath.row && indexPath.section == self.selectedIndexPath.section) {
        cell = (MSECalendarSelectedCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MSECalendarSelectedCollectionViewCell class]) forIndexPath:indexPath];
    }
    else {
        cell = (MSECalendarCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MSECalendarCollectionViewCell class]) forIndexPath:indexPath];
    }
    
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isScrolling = YES;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isScrolling && [self.delegate respondsToSelector:@selector(calendarScrolled)]) {
        [self.delegate calendarScrolled];
    }
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        self.isScrolling = NO;
        if ([self.delegate respondsToSelector:@selector(calendarFinishedScrolling)]) {
            [self.delegate calendarFinishedScrolling];
        }
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isScrolling = NO;
    if ([self.delegate respondsToSelector:@selector(calendarFinishedScrolling)]) {
        [self.delegate calendarFinishedScrolling];
    }
}

@end
