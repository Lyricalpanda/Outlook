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

@interface MSECalendarView()

@property (nonatomic, strong) NSMutableArray *weeks;
@property (nonatomic, strong) MSECalendarUtils *utils;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation MSECalendarView

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
        
        [self.collectionView setBackgroundColor:[UIColor redColor]];
        [self setBackgroundColor:[UIColor orangeColor]];

        [self initializeWeeksArray];
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
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
        [cell setBackgroundColor:[UIColor grayColor]];
    }
    else {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }

    
    if (![cell isKindOfClass:[MSECalendarSelectedCollectionViewCell class]]) {
        MSECalendarCollectionViewCell *mseCell = (MSECalendarCollectionViewCell *) cell;
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

- (void) selectedDate:(NSDate *)date {
    if ([self.selectedDate isEqualToDate:date]) {
        return;
    }
//    NSInteger dayOfTheWeek = [self.utils wee
    NSDate *week = [self.utils firstDayOfWeekFromDate:date];
    NSInteger row = [self.utils daysBetweenDate:week andDate:date];
    NSInteger section = [self.utils weeksBetweenDate:self.weeks[0] toDate:week];
    NSIndexPath *newPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSIndexPath *oldPath = self.selectedIndexPath;
    self.selectedIndexPath = newPath;
    self.selectedDate = date;
    
    if (oldPath) {
        [self.collectionView reloadItemsAtIndexPaths:@[self.selectedIndexPath, oldPath]];
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

    [self selectedDate:[self.utils addDays:indexPath.row toDate:[self.weeks objectAtIndex:indexPath.section]]];
    if ([self.delegate respondsToSelector:@selector(calendarSelectedDate:)]) {
        [self.delegate calendarSelectedDate:self.selectedDate];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Cell for section and row: %ld %ld", indexPath.section, indexPath.row);
    UICollectionViewCell *cell;
    
    if (indexPath.row == self.selectedIndexPath.row && indexPath.section == self.selectedIndexPath.section) {
        cell = (MSECalendarSelectedCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MSECalendarSelectedCollectionViewCell class]) forIndexPath:indexPath];
    }
    else {
        cell = (MSECalendarCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MSECalendarCollectionViewCell class]) forIndexPath:indexPath];
    }
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}


@end
