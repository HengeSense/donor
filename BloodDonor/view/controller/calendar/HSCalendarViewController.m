//
//  HSCalendarViewController.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 20.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSCalendarViewController.h"

#import <Parse/Parse.h>

#import "MBProgressHUD.h"
#import "HSBlockUIViewController.h"

#import "HSCalendar.h"
#import "HSCalendarDayButton.h"
#import "NSCalendar+HSCalendar.h"

#import "HSBloodRemoteEvent.h"
#import "HSBloodDonationEvent.h"
#import "HSBloodTestsEvent.h"

#import "HSEventViewController.h"
#import "HSEventPlanningViewController.h"
#import "CalendarInfoViewController.h"

#import "HSBaseLoginViewController.h"

@interface HSCalendarViewController ()<UIAlertViewDelegate>

/**
 * Current date displayed by calendar.
 */
@property (nonatomic, strong) NSDate *currentDate;

/**
 * Current month events. This set defined in loadEventsForDate: private method.
 */
@property (nonatomic, strong) NSSet *currentDateEvents;

/**
 * System calendar with ru_RU locale.
 */
@property (nonatomic, strong) NSCalendar *systemCalendar;

@property (nonatomic, strong) HSBlockUIViewController *blockUIViewController;

/// @name Methods for configuring UI.
- (void)configureNavigationItem;

/// @name Methods for updating UI components

/**
 * Loads events for the month, specified in date parameter, and updates calendar view.
 */
- (void)updateCalendarToDate: (NSDate *)date;

/**
 * Loads events from the calendar model to the view. Actualy now all events are loaded.
 */
- (void)loadEventsForDate: (NSDate *)date;

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

/**
 * Shows information about application.
 */
- (IBAction)showInfo: (id)sender;

/// @name Utility methods for UI components creation
- (HSCalendarDayButton *)createDayButtonWhithDate: (NSDate *)date frame: (CGRect)frame enabled: (BOOL)enabled;

/**
 * Removes all event buttons from the calendar view.
 */
- (void)clearCalendarView;

/// @name Representation conversion methods

/**
 * Converts specified month number from 1 to 12 to it's string representation.
 */
- (NSString *) nameForMonth: (size_t) monthNumber;

/// @name Authorization utility methods
/**
 * Returns YES, if user has already logged in.
 */
- (BOOL)userAuthorized;

- (void)showBlockUI;
- (void)hideBlockUI;
- (void)navigateToLoginPage;

@end

@implementation HSCalendarViewController

- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        self.currentDate = [NSDate date];
        self.systemCalendar = [NSCalendar currentCalendar];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.blockUIViewController = [[HSBlockUIViewController alloc] initWithNibName:@"HSBlockUIViewController"
                                                                           bundle:nil];
    [self configureNavigationItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    if ([self userAuthorized]) {
        [self hideBlockUI];
        [self updateCalendarToDate: self.currentDate];
    } else {
        [self showBlockUI];
        [self clearCalendarView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setCalendarImageView: nil];
    [self setMonthLabel: nil];
    [self setBlockUIViewController: nil];
    [super viewDidUnload];
}

#pragma mark - Actions handlers
- (IBAction)moveToNextMonth: (id)sender {
    NSDateComponents *dateComponents = [self.systemCalendar
            components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate: self.currentDate];
    ++dateComponents.month;
    [self updateCalendarToDate: [self.systemCalendar dateFromComponents: dateComponents]];
}

- (IBAction)moveToPreviousMonth: (id)sender {
    NSDateComponents *dateComponents = [self.systemCalendar
            components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate: self.currentDate];
    --dateComponents.month;
    [self updateCalendarToDate: [self.systemCalendar dateFromComponents: dateComponents]];
}

#pragma mark - Private interace implementation
#pragma mark - Configuring UI
- (void)configureNavigationItem {
    
    self.title = @"Календарь";
    self.navigationItem.backBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle: @"Назад" style: UIBarButtonItemStyleBordered
                                            target: nil action: nil];
    
    UIButton *infoButton = [UIButton buttonWithType: UIButtonTypeCustom];
    UIImage *infoImageNormal = [UIImage imageNamed: @"calendarInfoButtonNormal.png"];
    UIImage *infoImagePressed = [UIImage imageNamed: @"calendarInfoButtonPressed.png"];
    CGRect infoButtonFrame = CGRectMake(0, 0, infoImageNormal.size.width, infoImageNormal.size.height);
    [infoButton setImage: infoImageNormal forState: UIControlStateNormal];
    [infoButton setImage: infoImagePressed forState: UIControlStateHighlighted];
    infoButton.frame = infoButtonFrame;
    [infoButton addTarget: self action: @selector(showInfo:) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem *infoBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    self.navigationItem.rightBarButtonItem = infoBarButtonItem;
}

#pragma mark - Private methods for updating UI components
- (void)updateCalendarToDate: (NSDate *)date {
    THROW_IF_ARGUMENT_NIL(date, @"date is not specified");
    
    [self updateMonthLabelToDate: date];

    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo: self.navigationController.view animated: YES];
    [self.calendarModel pullEventsFromServer:^(BOOL success, NSError *error) {
        [progressHud hide: YES];
        if (success) {
            [self updateDaysButtonsToDate: date];
            self.currentDate = date;
        } else {
#warning TODO: Refactor to handle this situation more suitable
            [self clearCalendarView];
            NSLog(@"Unable to load remote events due to error: %@", error);
        }
    }];
}

-(void)loadEventsForDate: (NSDate *)date {
    THROW_IF_ARGUMENT_NIL(date, @"date is not specified");
}

- (void)updateMonthLabelToDate: (NSDate *)date {
    NSDateComponents *dateComponents =
            [self.systemCalendar components: NSYearCalendarUnit | NSMonthCalendarUnit fromDate: date];
    self.monthLabel.text = [NSString stringWithFormat: @"%@ (%d)",
            [self nameForMonth: dateComponents.month], dateComponents.year];
}

- (void)clearCalendarView {
    for (UIView *view in self.calendarImageView.subviews) {
        [view removeFromSuperview];
    }
}

- (void)updateDaysButtonsToDate: (NSDate *)date {
    
    [self clearCalendarView];
    
    // Create new buttons views
    NSDateComponents *dateComponents = [self.systemCalendar components: NSYearCalendarUnit | NSMonthCalendarUnit |
            NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate: date];

    NSDateComponents *visibleDayDateComponents = [self.systemCalendar firstWeekdayComponentsForDate: date];
    
    const NSUInteger DAYS_PER_WEEK = 7;
    const NSUInteger VISIBLE_DAYS_IN_CALENDAR_MONTH = 42;
    
    const NSUInteger DAY_BUTTON_INITIAL_X = 7;
    const NSUInteger DAY_BUTTON_INITIAL_Y = 26;
    const NSUInteger DAY_BUTTON_WIDTH = 44;
    const NSUInteger DAY_BUTTON_HEIGHT = 42;

    CGRect dayButtonFrame = CGRectMake(DAY_BUTTON_INITIAL_X, DAY_BUTTON_INITIAL_Y, DAY_BUTTON_WIDTH, DAY_BUTTON_HEIGHT);
    
    for (NSUInteger dayPos = 0; dayPos < VISIBLE_DAYS_IN_CALENDAR_MONTH; ++dayPos) {
        if (dayPos != 0 && (dayPos % DAYS_PER_WEEK == 0)) {
            dayButtonFrame.origin.y += DAY_BUTTON_HEIGHT;
            dayButtonFrame.origin.x = DAY_BUTTON_INITIAL_X;
        }

        NSDate *dayDate = [self.systemCalendar dateFromComponents: visibleDayDateComponents];
        BOOL dayButtonEnabled = visibleDayDateComponents.month == dateComponents.month ? YES : NO;
        HSCalendarDayButton *dayButton = [self createDayButtonWhithDate: dayDate frame: dayButtonFrame
                                                                enabled: dayButtonEnabled];
        
        NSArray *dayEvents = [self.calendarModel eventsForDay: dayDate];
        for (HSEvent *event in dayEvents) {
            [dayButton addEvent: event];
        }
        
        ++visibleDayDateComponents.day;
        visibleDayDateComponents =
                [self.systemCalendar components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
                NSWeekdayCalendarUnit fromDate: [self.systemCalendar dateFromComponents: visibleDayDateComponents]];
        [self.calendarImageView addSubview: dayButton];
        dayButtonFrame.origin.x += DAY_BUTTON_WIDTH;
    }
}

#pragma mark - Private action methods
- (void)showInfo: (id)sender {
    CalendarInfoViewController *calendarInfoViewController = [[CalendarInfoViewController alloc]
            initWithNibName: @"CalendarInfoViewController" bundle: nil];
    [self.navigationController pushViewController:calendarInfoViewController animated:YES];
}

- (IBAction)dayButtonClicked: (id)sender {
    HSCalendarDayButton *dayButton = (HSCalendarDayButton *)sender;
    
    NSSet *remoteBloodEvents = [[dayButton allEvents]
            filteredSetUsingPredicate: [NSPredicate predicateWithFormat: @"self isKindOfClass: %@",
            [HSBloodRemoteEvent class]]];
    
    const size_t BLOOD_REMOTE_EVENTS_PER_DAY_MAX = 1;
    if (remoteBloodEvents.count > BLOOD_REMOTE_EVENTS_PER_DAY_MAX) {
        [NSException exceptionWithName: NSInternalInconsistencyException
                reason: [NSString stringWithFormat: @"Supported count of remote events per day is %zu,"
                        " but actual value is greater.", BLOOD_REMOTE_EVENTS_PER_DAY_MAX] userInfo: nil];
    }
    
    HSBloodDonationEvent *bloodDonationEvent = nil;
    HSBloodTestsEvent *bloodTestsEvent = nil;
    for (HSBloodRemoteEvent *remoteBloodEvent in remoteBloodEvents) {
        if ([remoteBloodEvent isKindOfClass: [HSBloodDonationEvent class]]) {
            bloodDonationEvent = (HSBloodDonationEvent *)remoteBloodEvent;
        } else if ([remoteBloodEvent isKindOfClass: [HSBloodTestsEvent class]]) {
            bloodTestsEvent = (HSBloodTestsEvent *)remoteBloodEvent;
        }
    }
    
    UIViewController *pushedViewController = nil;
    if (bloodDonationEvent != nil) {
        // only blood donation event specified
        pushedViewController = [[HSEventViewController alloc] initWithNibName: @"HSEventViewController"
                bundle: nil calendar: self.calendarModel bloodDonationEvent: bloodDonationEvent];
    } else if (bloodTestsEvent != nil) {
        // only blood tests event specified
        pushedViewController = [[HSEventViewController alloc] initWithNibName: @"HSEventViewController"
                bundle: nil calendar: self.calendarModel bloodTestsEvent: bloodTestsEvent];
    } else {
        // no events was specified on this day, so it should be created
        pushedViewController = [[HSEventPlanningViewController alloc] initWithNibName: @"HSEventPlanningViewController"
                bundle: nil calendar: self.calendarModel date: dayButton.date];
    }
    
    [self.navigationController pushViewController: pushedViewController animated: YES];
}

#pragma mark - Private utility methods for UI components creation
- (HSCalendarDayButton *)createDayButtonWhithDate: (NSDate *)date frame: (CGRect)frame enabled: (BOOL)enabled {
    HSCalendarDayButton *dayButton = [[HSCalendarDayButton alloc] initWithFrame: frame date: date];
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

#pragma mark - Private authorization utility methods
- (BOOL)userAuthorized {
    return self.calendarModel != nil && [PFUser currentUser] != nil;
}

- (void)showBlockUI {
    self.blockUIViewController.blockMessage = @"";
    [self.blockUIViewController.view removeFromSuperview];
    [self.view addSubview: self.blockUIViewController.view];
    
    NSString *alertTitle = @"Внимание";
    NSString *alertMessage = @"Планирование событий недоступно. Выполните вход.";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self
                                          cancelButtonTitle:@"Отмена" otherButtonTitles:@"Вход", nil];
    [alert show];
}
- (void)hideBlockUI {
    [self.blockUIViewController.view removeFromSuperview];
}

- (void)navigateToLoginPage {
    self.tabBarController.selectedIndex = 3;
}

#pragma mark - UIAlertViewDelegate protocol implementation
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self navigateToLoginPage];
    }
}
@end
