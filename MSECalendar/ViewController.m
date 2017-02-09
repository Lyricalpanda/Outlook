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
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *weeks;

@property (nonatomic, strong) MSECalendarViewModel *calendarViewModel;
@property (nonatomic, weak) IBOutlet MSEAgendaViewModel *agendaViewModel;

@end

@implementation ViewController

- (void)dateScrolled:(NSString *)date {
    NSLog(@"Date : %@", date);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.weeks = [@[] mutableCopy];
    
    self.calendarViewModel = [MSECalendarViewModel new];
    [self.agendaViewModel setDelegate:self];
    self.utils = [MSECalendarUtils new];
//    self.agendaViewModel = [MSEAgendaViewModel new];
    
    [self initCollectionView];
    [self initializeWeeksArray];
//    [self initTableView];
//    [self.agendaViewModel setBackgroundColor:[UIColor redColor]];
    [self.collectionView reloadData];
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

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.collectionView layoutIfNeeded];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void) viewWillAppear:(BOOL)animated {
    NSDate *firstDate = [self.weeks objectAtIndex:0];
    NSDate *lastDate = [self.utils addDays:6 toDate:[self.weeks lastObject]];
    [self.agendaViewModel loadAgendaFromDate:firstDate toDate:lastDate];
}

- (void) initTableView {
//    [self.tableView setDataSource:self.agendaViewModel];
//    [self.tableView setDelegate:self.agendaViewModel];
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MSEAgendaEmptyTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MSEAgendaEmptyTableViewCell class])];
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MSEAgendaEventTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MSEAgendaEventTableViewCell class])];
//    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MSEAgendaHeaderFooterView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MSEAgendaHeaderFooterView class])];
}

- (void)initCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.itemSize =CGSizeMake(self.collectionView.frame.size.width/7, self.collectionView.frame.size.height/5);
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MSECalendarSelectedCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MSECalendarSelectedCollectionViewCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MSECalendarCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([MSECalendarCollectionViewCell class])];
    [self.collectionView setDataSource:self.calendarViewModel];
    [self.collectionView setDelegate:self.calendarViewModel];
}


@end
