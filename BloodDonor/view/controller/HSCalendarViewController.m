//
//  HSCalendarViewController.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 20.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSCalendarViewController.h"

#import "HSCalebdarDayButton.h"
#import "NSCalendar+HSCalendar.h"

@interface HSCalendarViewController ()

/**
 * Current date displayed by calendar.
 */
@property (nonatomic, strong) NSDate *currentDate;

/**
 * System calendar with ru_RU locale.
 */
@property (nonatomic, strong) NSCalendar *calendar;

/// @name Methods for updating UI components

/**
 * Loads events for the month, specified in date parameter, and updates calendar view.
 */
- (void)updateCalendarToDate: (NSDate *)date;

/**
 * Updates calendar month label property correspond to the specified date.
 */
- (void)updateMonthLabelToDate: (NSDate *)date;

/**
 * Replace old day buttons with new one.
 */
- (void)updateDaysButtonsToDate: (NSDate *)date;

/// @name  Action methods

/**
 * Handler for all calendar day buttons.
 */
- (IBAction)dayButtonClicked: (id)sender;

/// @name Utility methods for UI components creation
- (HSCalebdarDayButton *)createDayButtonWhithDate: (NSDate *)date frame: (CGRect)frame enabled: (BOOL)enabled;

/// @name Representation conversion methods

/**
 * Converts specified month number from 1 to 12 to it's string representation.
 */
- (NSString *) nameForMonth: (size_t) monthNumber;

@end

@implementation HSCalendarViewController

- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        self.currentDate = [NSDate date];
        self.calendar = [NSCalendar currentCalendar];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateCalendarToDate: [NSDate date]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setCalendarImageView: nil];
    [self setMonthLabel: nil];
    [super viewDidUnload];
}

#pragma mark - Actions handlers
- (IBAction)moveToNextMonth: (id)sender {
    NSDateComponents *dateComponents = [self.calendar
            components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate: self.currentDate];
    ++dateComponents.month;
    [self updateCalendarToDate: [self.calendar dateFromComponents: dateComponents]];
}

- (IBAction)moveToPreviousMonth: (id)sender {
    NSDateComponents *dateComponents = [self.calendar
            components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate: self.currentDate];
    --dateComponents.month;
    [self updateCalendarToDate: [self.calendar dateFromComponents: dateComponents]];
}

#pragma mark - Private interace implementation
#pragma mark - Private methods for updating UI components
- (void)updateCalendarToDate: (NSDate *)date {
    THROW_IF_ARGUMENT_NIL(date, @"date is not specified");
    [self updateMonthLabelToDate:date];
    [self updateDaysButtonsToDate: date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yy-MM-dd"];
    
    NSLog(@"Calendar date was updated to: %@", [dateFormatter stringFromDate: date]);
    self.currentDate = date;
}

- (void)updateMonthLabelToDate: (NSDate *)date {
    NSDateComponents *dateComponents =
            [self.calendar components: NSYearCalendarUnit | NSMonthCalendarUnit fromDate: date];
    self.monthLabel.text = [NSString stringWithFormat: @"%@ (%d)",
            [self nameForMonth: dateComponents.month], dateComponents.year];
}

- (void)updateDaysButtonsToDate: (NSDate *)date {
    
    // Removes old buttons views
    for (UIView *view in self.calendarImageView.subviews) {
        [view removeFromSuperview];
    }
    
    // Create new buttons views
    NSDateComponents *dateComponents = [self.calendar components: NSYearCalendarUnit | NSMonthCalendarUnit |
            NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate: date];

    NSDateComponents *visibleDayDateComponents = [self.calendar firstWeekdayComponentsForDate: date];
    
    const NSUInteger DAYS_PER_WEEK = 7;
    const NSUInteger VISIBLE_DAYS_IN_CALENDAR_MONTH = 42;
    
    const NSUInteger DAY_BUTTON_INITIAL_X = 7;
    const NSUInteger DAY_BUTTON_INITIAL_Y = 25;
    const NSUInteger DAY_BUTTON_WIDTH = 44;
    const NSUInteger DAY_BUTTON_HEIGHT = 42;

    CGRect dayButtonFrame = CGRectMake(DAY_BUTTON_INITIAL_X, DAY_BUTTON_INITIAL_Y, DAY_BUTTON_WIDTH, DAY_BUTTON_HEIGHT);
    
    for (NSUInteger dayPos = 0; dayPos < VISIBLE_DAYS_IN_CALENDAR_MONTH; ++dayPos) {
        if (dayPos != 0 && (dayPos % DAYS_PER_WEEK == 0)) {
            dayButtonFrame.origin.y += DAY_BUTTON_HEIGHT;
            dayButtonFrame.origin.x = DAY_BUTTON_INITIAL_X;
        }

        NSDate *dayDate = [self.calendar dateFromComponents: visibleDayDateComponents];
        BOOL dayButtonEnabled = visibleDayDateComponents.month == dateComponents.month ? YES : NO;
        UIButton *dayButton = [self createDayButtonWhithDate: dayDate frame: dayButtonFrame
                                                     enabled: dayButtonEnabled];
        
        ++visibleDayDateComponents.day;
        visibleDayDateComponents = [self.calendar components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
                NSWeekdayCalendarUnit fromDate: [self.calendar dateFromComponents: visibleDayDateComponents]];
        [self.calendarImageView addSubview: dayButton];
        dayButtonFrame.origin.x += 44;
    }
    
    NSLog(@"Day of weak: %d", dateComponents.weekday);
}

#pragma mark - Private action methods
- (IBAction)dayButtonClicked: (id)sender {
    UIButton *dayButton = (UIButton *)sender;
    NSLog(@"Clicked day button with title: %@", dayButton.titleLabel.text);
}

#pragma mark - Private utility methods for UI components creation
- (HSCalebdarDayButton *)createDayButtonWhithDate: (NSDate *)date frame: (CGRect)frame enabled: (BOOL)enabled {
    HSCalebdarDayButton *dayButton = [[HSCalebdarDayButton alloc] initWithFrame: frame date: date];
    dayButton.enabled = enabled;
    [dayButton addTarget: self action: @selector(dayButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    return dayButton;
}


#pragma mark - Private representation conversion methods
- (NSString *)nameForMonth: (size_t)month {
    switch (month)
    {
        case 1:
            return @"Январь";
        case 2:
            return @"Февраль";
        case 3:
            return @"Март";
        case 4:
            return @"Апрель";
        case 5:
            return @"Май";
        case 6:
            return @"Июнь";
        case 7:
            return @"Июль";
        case 8:
            return @"Август";
        case 9:
            return @"Сентябрь";
        case 10:
            return @"Октябрь";
        case 11:
            return @"Ноябрь";
        case 12:
            return @"Декабрь";
        default:
            return @"?";
            
    }
}
@end
