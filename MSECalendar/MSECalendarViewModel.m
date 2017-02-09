//
//  MSECalendarViewModel.m
//  MSECalendar
//
//  Created by Eric Harmon on 2/6/17.
//  Copyright © 2017 Eric Harmon. All rights reserved.
//

#import "MSECalendarViewModel.h"
#import "MSECalendarCollectionViewCell.h"
#import "MSECalendarSelectedCollectionViewCell.h"
#import "MSECalendarUtils.h"
#import "MSEMonth.h"

@interface MSECalendarViewModel()

@property (nonatomic, strong) NSMutableArray *weeks;
@property (nonatomic, strong) MSECalendarUtils *utils;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation MSECalendarViewModel

//- (instancetype) init {
//    self = [super init];
//    if (self ) {
//        self.weeks = [@[] mutableCopy];
//        self.utils = [MSECalendarUtils new];
//        [self initializeWeeksArray];
//    }
//    return self;
//}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.weeks = [@[] mutableCopy];
        self.utils = [MSECalendarUtils new];
        
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.itemSize =CGSizeMake(self.frame.size.width/7, self.frame.size.height/5);
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
        [self addSubview:self.collectionView];

        [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MSECalendarSelectedCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MSECalendarSelectedCollectionViewCell class])];
        [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MSECalendarCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MSECalendarCollectionViewCell class])];
        [self.collectionView setDataSource:self];
        [self.collectionView setDelegate:self];
        
        [self initializeWeeksArray];
    }
    return self;
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
    if (![cell isKindOfClass:[MSECalendarSelectedCollectionViewCell class]]) {
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
    
}

- (void)incrementDate {
    if (self.selectedIndexPath.row == 6 && self.selectedIndexPath.section == [self.weeks count] - 1) {
        return;
    }
    
    NSIndexPath *previousPath = self.selectedIndexPath;
    self.selectedDate = [self.utils addDays:1 toDate:self.selectedDate];

    if (self.selectedIndexPath.row == 6) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:self.selectedIndexPath.section + 1];
    }
    else {
        self.selectedIndexPath = [NSIndexPath indexPathForRow:self.selectedIndexPath.row+1 inSection:self.selectedIndexPath.section];
    }
    
    if (previousPath) {
        [self.collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath, previousPath]];
    }
    else {
        [self.collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath]];
    }
}

- (void) decrementDate {
    if (self.selectedIndexPath.row == 0 && self.selectedIndexPath.section == 0) {
        return;
    }
    
    NSIndexPath *previousPath = self.selectedIndexPath;
    self.selectedDate = [self.utils addDays:-1 toDate:self.selectedDate];
    
    if (self.selectedIndexPath.row == 0) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow:6 inSection:self.selectedIndexPath.section - 1];
    }
    else {
        self.selectedIndexPath = [NSIndexPath indexPathForRow:self.selectedIndexPath.row-1 inSection:self.selectedIndexPath.section];
    }
    
    if (previousPath) {
        [self.collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath, previousPath]];
    }
    else {
        [self.collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath]];
    }

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MSECalendarCollectionViewCell *cell = (MSECalendarCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MSECalendarCollectionViewCell class]) forIndexPath:indexPath];
    if (self.selectedIndexPath == indexPath) {
        return;
    }

    self.selectedDate = [self.utils addDays:indexPath.row toDate:[self.weeks objectAtIndex:indexPath.section]];
    NSIndexPath *previousPath = self.selectedIndexPath;
    self.selectedIndexPath = indexPath;
    if (previousPath){
        [collectionView reloadItemsAtIndexPaths:@[indexPath, previousPath]];
    }
    else {
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Cell for section and row: %ld %ld", indexPath.section, indexPath.row);
    UICollectionViewCell *cell;
    
    if (indexPath.row == self.selectedIndexPath.row && indexPath.section == self.selectedIndexPath.section) {
        cell = (MSECalendarSelectedCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MSECalendarSelectedCollectionViewCell class]) forIndexPath:indexPath];
//        [cell dateSelected:YES];
    }
    else {
        cell = (MSECalendarCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MSECalendarCollectionViewCell class]) forIndexPath:indexPath];
        //        [(MSECalendarCollectionViewCell *)cell dateSelected:NO];

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

//- (MSEMonth *)getPreviousMonth:(MSEMonth *)currentMonth {
//    MSEMonth *newMonth = [MSEMonth new];
//    if (currentMonth.month == 1) {
//        newMonth.month = 12;
//        newMonth.year = currentMonth.year - 1;
//    }
//    else {
//        newMonth.month = currentMonth.month - 1;
//        newMonth.year = currentMonth.year;
//    }
//    
//    return newMonth;
//}
//
//- (MSEMonth *)getNextMonth:(MSEMonth *)currentMonth {
//    MSEMonth *newMonth = [MSEMonth new];
//    if (currentMonth.month == 12) {
//        newMonth.month = 1;
//        newMonth.year = currentMonth.year + 1;
//    }
//    else {
//        newMonth.month = currentMonth.month + 1;
//        newMonth.year = currentMonth.year;
//    }
//    
//    return newMonth;
//}
//

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
