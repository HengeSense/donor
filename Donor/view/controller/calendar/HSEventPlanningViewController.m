//
//  HSEventPlanningViewController.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 25.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSEventPlanningViewController.h"
#import "HSBloodDonationTypePicker.h"
#import "HSDateTimePicker.h"
#import "HSAddressPicker.h"
#import "HSAlertViewController.h"
#import "HSRemindDatePicker.h"

#import "NSDate+HSCalendar.h"
#import "UIView+HSLayoutManager.h"

#import "MBProgressHUD.h"
#import "HSFlurryAnalytics.h"

#pragma mark - Private types
typedef enum {
    HSEventPlanningViewControllerMode_BloodDonation = 0,
    HSEventPlanningViewControllerMode_BloodTest
} HSEventPlanningViewControllerMode;

#pragma mark - Private constants
#pragma mark - Default time for created events
static const NSUInteger kEventDefaultTimeHour = 8;
static const NSUInteger kEventDefaultTimeMinute = 0;

static const NSUInteger kEventLocalNotificationReminderTimeDefault_Hour = 12;
static const NSUInteger kEventLocalNotificationReminderTimeDefault_Minute = 0;

#pragma mark - Animation constants
static const CGFloat kViewAppearanceDuration = 0.5f;
static const CGFloat kViewMovementDuration = 0.5f;

#pragma mark - UI labels constants
static NSString * const kBloodDonationEventTypeLabel_Donation = @"Кроводача";
static NSString * const kBloodDonationEventTypeLabel_Test = @"Анализ";

#pragma mark - UI keyboard and it's animation constants
static const CGFloat kViewShiftedByKeyboardDuration = 0.3f;
static const CGFloat kTabBarHeight = 55.0f;

#pragma mark - UI text fields constants
static const NSUInteger kCommentsTextViewSymbolsMax = 260;

#pragma mark - Private interface declaration
@interface HSEventPlanningViewController () <UITextViewDelegate>

/**
 * Contains current view controller displaying mode.
 */
@property (nonatomic, assign) HSEventPlanningViewControllerMode currentViewMode;

/**
 * Reference to the calendar model.
 */
@property (nonatomic, strong) HSCalendar *calendar;

/**
 * Original blood donation event.
 */
@property (nonatomic, strong) HSBloodDonationEvent *originalBloodDonationEvent;

/**
 * Original blood test event.
 */
@property (nonatomic, strong) HSBloodTestsEvent *originalBloodTestsEvent;

/**
 * Weak reference to the current edited event.
 */
@property (nonatomic, weak) HSBloodRemoteEvent *currentOriginalEvent;

/**
 * Handles initial date, used for creating new event.
 */
@property (nonatomic, strong) NSDate *initialDate;

/**
 * Edited blood donation event.
 */
@property (nonatomic, strong) HSBloodDonationEvent *bloodDonationEvent;

/**
 * Edited blood test event.
 */
@property (nonatomic, strong) HSBloodTestsEvent *bloodTestsEvent;

/**
 * Weak reference to the current edited event.
 */
@property (nonatomic, weak) HSBloodRemoteEvent *currentEditedEvent;

/**
 * This property stores initial frame of the flexible UI element.
 */
@property (nonatomic, assign) CGRect flexibleViewInitialFrame;

/**
 * View controller for selecting blood donation type.
 */
@property (nonatomic, strong) HSBloodDonationTypePicker *bloodDonationTypePicker;

/**
 * View controller for selecting date and time.
 */
@property (nonatomic, strong) HSDateTimePicker *dateTimePicker;

/**
 * View controller for selecting blood donation laboratory address.
 */
@property (nonatomic, strong) HSAddressPicker *addressPicker;

/**
 * View controller for selecting reminder date interval.
 */
@property (nonatomic, strong) HSRemindDatePicker *reminderDatePicker;

/**
 * Initialises HSEventPlanningViewController to edit existing blood donation event and blood test event.
 */
- (id) initWithNibNameInternal: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil
                      calendar: (HSCalendar *)calendar date: (NSDate *)date
            bloodDonationEvent: (HSBloodDonationEvent *)bloodDonationEvent
                bloodTestEvent: (HSBloodTestsEvent *)bloodTestsEvent;

/**
 * Configures view for editing existing blood donation event.
 */
- (void)configureViewForEditingBloodDonationEvent;

/**
 * Configures view for editing existing blood test event.
 */
- (void)configureViewForEditingBloodTestEvent;

/// @name Private UI utility methods
- (void)sayThanksToUser;

/// @name Private UI action handlers

/**
 * Handler for "Готово" button - add planning event to the calendar.
 */
- (void)donePlanningButtonClicked: (id)sender;

/**
 * Handler for "Отмена" button - do not add planning event to the calendar.
 */
- (void)cancelPlanningButtonClicked: (id)sender;

/// @name Keyboard interaction

@property (nonatomic, assign) BOOL isKeyboardShown;

/**
 * Register observers for keyboard events: show, hide.
 */
- (void)registerKeyboardEventsObserver;

/**
 * Unregister observers for keyboard events: show, hide.
 */
- (void)unregisterKeyboardEventListener;

/**
 * Handles keyboard show event.
 */
- (void)keyboardWillShow: (NSNotification *)notification;

/**
 * Handles keyboard hide event.
 */
- (void)keyboardWillHide: (NSNotification *)notification;

/// @name Utility methods

/**
 * Calculates first date availbale for planning blood donation.
 */
- (NSDate *)calculateFirstAvailableDateForPlanning;

/**
 * Calculate last date available for blood donation.
 */
- (NSDate *)calculateLastAvailableDateForPlanning;

@end

#pragma mark - Public and private interface implmentation
@implementation HSEventPlanningViewController

#pragma mark - Initialization
- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil calendar: (HSCalendar *)calendar
                 date: (NSDate *)date {
    return [self initWithNibNameInternal: nibNameOrNil bundle: nibBundleOrNil calendar: calendar date: date
            bloodDonationEvent: nil bloodTestEvent: nil];
}

- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil calendar: (HSCalendar *)calendar
                 date: (NSDate *)date bloodDonationEvent: (HSBloodDonationEvent *)bloodDonationEvent {
    THROW_IF_ARGUMENT_NIL(bloodDonationEvent)
    return [self initWithNibNameInternal: nibNameOrNil bundle: nibBundleOrNil calendar: calendar date: date
            bloodDonationEvent: bloodDonationEvent bloodTestEvent: nil];
}

- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil calendar: (HSCalendar *)calendar
                 date: (NSDate *)date bloodTestsEvent: (HSBloodTestsEvent *)bloodTestsEvent {
    THROW_IF_ARGUMENT_NIL(bloodTestsEvent)
    return [self initWithNibNameInternal: nibNameOrNil bundle: nibBundleOrNil calendar: calendar date: date
            bloodDonationEvent: nil bloodTestEvent: bloodTestsEvent];
}

- (id)initWithNibNameInternal: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil
                     calendar: (HSCalendar *)calendar
                         date: (NSDate *)date bloodDonationEvent: (HSBloodDonationEvent *)bloodDonationEvent
               bloodTestEvent: (HSBloodTestsEvent *)bloodTestsEvent {
    
    THROW_IF_ARGUMENT_NIL(calendar);
    THROW_IF_ARGUMENT_NIL(date);
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        // UI
        self.title = @"Планирование";
        // Core
        self.calendar = calendar;
        self.initialDate = date;
        self.currentViewMode = HSEventPlanningViewControllerMode_BloodDonation;
        self.originalBloodDonationEvent = bloodDonationEvent;
        self.originalBloodTestsEvent = bloodTestsEvent;
        
        self.bloodDonationEvent = [bloodDonationEvent copy];
        self.bloodTestsEvent = [bloodTestsEvent copy];
    }
    return self;
}


#pragma mark - UI life cycle
- (void) configureNavigationBar {
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Назад" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    UIImage *barImageNormal = [UIImage imageNamed:@"barButtonNormal"];
    UIImage *barImagePressed = [UIImage imageNamed:@"barButtonPressed"];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect cancelButtonFrame = CGRectMake(0, 0, barImageNormal.size.width, barImageNormal.size.height);
    [cancelButton setBackgroundImage:barImageNormal forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:barImagePressed forState:UIControlStateHighlighted];
    [cancelButton setTitle:@"Отмена" forState:UIControlStateNormal];
    [cancelButton setTitle:@"Отмена" forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    cancelButton.frame = cancelButtonFrame;
    [cancelButton addTarget:self action:@selector(cancelPlanningButtonClicked:)
           forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    [cancelBarButtonItem setTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect doneButtonFrame = CGRectMake(0, 0, barImageNormal.size.width, barImageNormal.size.height);
    [doneButton setBackgroundImage:barImageNormal forState:UIControlStateNormal];
    [doneButton setBackgroundImage:barImagePressed forState:UIControlStateHighlighted];
    [doneButton setTitle:@"Готово" forState:UIControlStateNormal];
    [doneButton setTitle:@"Готово" forState:UIControlStateHighlighted];
    doneButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    doneButton.frame = doneButtonFrame;
    [doneButton addTarget:self action:@selector(donePlanningButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    [doneBarButtonItem setTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = doneBarButtonItem;
}

- (void)configureComponents {
    [self.rootScrollView addSubview: self.contentView];
    self.rootScrollView.contentSize = self.contentView.bounds.size;
    self.commentsTextView.backgroundColor = [UIColor colorWithPatternImage:
                                             [UIImage imageNamed: @"eventCommentBackground.png"]];
    
    self.flexibleViewInitialFrame = self.dataAndPlaceView.frame;
    
    self.bloodDonationTypePicker = [[HSBloodDonationTypePicker alloc] initWithNibName: @"HSBloodDonationTypePicker"
                                                                               bundle: nil];
    self.dateTimePicker = [[HSDateTimePicker alloc] initWithNibName: @"HSDateTimePicker" bundle: nil];
    self.addressPicker = [[HSAddressPicker alloc] initWithNibName: @"HSAddressPicker" bundle: nil];
    self.reminderDatePicker = [[HSRemindDatePicker alloc] initWithNibName:NSStringFromClass([HSRemindDatePicker class])
                                                                   bundle:nil];
    
    [self.removeRemoteEventButton setBackgroundImage: [UIImage imageNamed: @"delete_mark_active.png"]
                                            forState: UIControlStateNormal];
    [self.removeRemoteEventButton setBackgroundImage: [UIImage imageNamed: @"delete_mark_pressed.png"]
                                            forState: UIControlStateHighlighted];
    self.removeRemoteEventButton.enabled =
            self.originalBloodDonationEvent != nil || self.originalBloodTestsEvent != nil;
}

- (void)configureViewMode {
    if (self.bloodDonationEvent != nil) {
        [self configureViewForEditingBloodDonationEvent];
        if (self.bloodTestsEvent == nil) {
            self.bloodTestsEvent = [[HSBloodTestsEvent alloc] init];
            self.bloodTestsEvent.scheduleDate = [self.initialDate dateMovedToHour: kEventDefaultTimeHour
                                                                            minute: kEventDefaultTimeMinute];
        }
    } else if (self.bloodTestsEvent != nil) {
        [self configureViewForEditingBloodTestEvent];
        self.bloodDonationEvent = [[HSBloodDonationEvent alloc] init];
        self.bloodDonationEvent.scheduleDate = [self.initialDate dateMovedToHour: kEventDefaultTimeHour
                                                                           minute: kEventDefaultTimeMinute];
        self.bloodDonationEvent.bloodDonationType = HSBloodDonationType_Blood;
    } else {
        self.bloodDonationEvent = [[HSBloodDonationEvent alloc] init];
        self.bloodDonationEvent.scheduleDate = [self.initialDate dateMovedToHour: kEventDefaultTimeHour
                                                                           minute: kEventDefaultTimeMinute];

        self.bloodDonationEvent.bloodDonationType = HSBloodDonationType_Blood;
        self.bloodTestsEvent = [[HSBloodTestsEvent alloc] init];
        self.bloodTestsEvent.scheduleDate = [self.initialDate dateMovedToHour: kEventDefaultTimeHour
                                                                        minute: kEventDefaultTimeMinute];

        [self configureViewForEditingBloodDonationEvent];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBar];
    [self configureComponents];
    [self configureViewMode];
    [self registerKeyboardEventsObserver];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rootScrollView adjustAsContentView];
}

- (void)dealloc {
    [self unregisterKeyboardEventListener];
}

#pragma mark - User's interaction hadlers
- (IBAction)removeBloodEvent: (id)sender {
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo: self.navigationController.view animated: YES];
    
#warning Crash point. Check event existance.
    [self.calendar removeBloodRemoteEvent: self.currentOriginalEvent completion: ^(BOOL success, NSError *error) {
        [progressHud hide: YES];
        if (success) {
            [HSFlurryAnalytics userDeletedCalendarEvent:self.currentEditedEvent];
            [self.navigationController popToRootViewControllerAnimated: YES];
        } else {
            [HSAlertViewController showWithTitle:@"Ошибка" message:[HSModelCommon localizedDescriptionForError:error]];
        }
    }];
}

- (IBAction)changeBloodDonationEventType: (id)sender {
    switch (self.currentViewMode) {
        case HSEventPlanningViewControllerMode_BloodDonation:
            [self configureViewForEditingBloodTestEvent];
            break;
        case HSEventPlanningViewControllerMode_BloodTest:
            [self configureViewForEditingBloodDonationEvent];
            break;
        default:
            @throw [NSException exceptionWithName: NSInternalInconsistencyException
                    reason: @"Unknown event planning view controller mode" userInfo: nil];
            break;
    }
}

- (IBAction)selectBloodDonationType: (id)sender {
    [self.bloodDonationTypePicker showWithBloodDonationType:self.bloodDonationEvent.bloodDonationType
            completion:^(BOOL isDone)
    {
        if (isDone) {
            self.bloodDonationTypeLabel.text =
                    bloodDonationTypeToString(self.bloodDonationTypePicker.bloodDonationType);
            self.bloodDonationEvent.bloodDonationType = self.bloodDonationTypePicker.bloodDonationType;
        }
    }];
}

- (IBAction)selectBloodDonationCenterAddress: (id)sender {
    self.addressPicker.selectedAddress = self.currentEditedEvent.labAddress;
    [self.addressPicker showWithCompletion: ^(BOOL isDone) {
        if (isDone) {
            self.currentEditedEvent.labAddress = self.addressPicker.selectedAddress;
            [self updateUIComponents];
        }
    }];
}

- (IBAction)selectBloodDonationEventDate: (id)sender {
    NSDate *startDate = [self calculateFirstAvailableDateForPlanning];
    NSDate *endDate = [self calculateLastAvailableDateForPlanning];
            [self.dateTimePicker showWithStartDate: startDate endDate: endDate
                                       currentDate: self.currentEditedEvent.scheduleDate completion: ^(BOOL isDone)
    {
        if (isDone) {
            self.currentEditedEvent.scheduleDate = self.dateTimePicker.selectedDate;
            [self updateUIComponents];
        }
    }];
}

- (IBAction)selectBloodDonationReminderDate:(id)sender {
    [self.reminderDatePicker showWithInitialReminderTimeInterval:[self.currentEditedEvent reminderTimeShift]
            completion: ^(BOOL isDone)
    {
        if (isDone) {
            NSTimeInterval reminderTimeShift = self.reminderDatePicker.reminderTimeShift;
            self.currentEditedEvent.reminderFireDate = reminderTimeShift >= 0 ?
                    [self.currentEditedEvent.scheduleDate dateByAddingTimeInterval:-reminderTimeShift] : nil;
            [self updateUIComponents];
        }
    }];
}

#pragma mark - UI delegation protocols implementation
#pragma mark - UITextViewDelegate protocol implementation
- (BOOL)textView: (UITextView *)textView shouldChangeTextInRange: (NSRange)range replacementText: (NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    } else if (self.commentsTextView.text.length > kCommentsTextViewSymbolsMax) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Private interface implementation
#pragma mark - Configuring HSEventPlanningViewController for different modes
- (void)configureViewForEditingBloodDonationEvent {
    if (self.bloodDonationEvent == nil) {
        [NSException exceptionWithName: NSInternalInconsistencyException
                reason: @"bloodDonationEvent property is not defined" userInfo: nil];
    }
    self.currentEditedEvent = self.bloodDonationEvent;
    self.currentOriginalEvent = self.originalBloodDonationEvent;
    
    self.bloodDonationEventTypeLabel.text = kBloodDonationEventTypeLabel_Donation;
    self.bloodDonationTypeLabel.text = bloodDonationTypeToString(self.bloodDonationEvent.bloodDonationType);
    if (self.bloodDonationTypeView.isHidden || self.bloodDonationTypeView.alpha <= 0.0f) {
        [UIView animateWithDuration: kViewMovementDuration animations:^{
            self.dataAndPlaceView.frame = self.flexibleViewInitialFrame;
            self.bloodDonationTypeView.alpha = 1.0f;
        }];
        self.currentViewMode = HSEventPlanningViewControllerMode_BloodDonation;
    }
    [self updateUIComponents];
}

- (void)configureViewForEditingBloodTestEvent {
    if (self.bloodTestsEvent == nil) {
        [NSException exceptionWithName: NSInternalInconsistencyException
                                reason: @"bloodTestEvent property is not defined" userInfo: nil];
    }
    self.currentEditedEvent = self.bloodTestsEvent;
    self.currentOriginalEvent = self.originalBloodTestsEvent;

    self.bloodDonationEventTypeLabel.text = kBloodDonationEventTypeLabel_Test;
    if (!self.bloodDonationTypeView.isHidden || self.bloodDonationTypeView.alpha >= 1.0) {
        [UIView animateWithDuration: kViewMovementDuration animations:^{
            CGRect currentBloodDonationTypeFrame = self.bloodDonationTypeView.frame;
            CGRect currentDataAndPlaceFrame = self.dataAndPlaceView.frame;
            CGRect updatedFrame = CGRectMake(currentBloodDonationTypeFrame.origin.x,
                                             currentBloodDonationTypeFrame.origin.y,
                                             currentDataAndPlaceFrame.size.width,
                                             currentDataAndPlaceFrame.size.height);
            self.dataAndPlaceView.frame = updatedFrame;
            self.bloodDonationTypeView.alpha = 0.0f;
        }];
        self.currentViewMode = HSEventPlanningViewControllerMode_BloodTest;
    }
    [self updateUIComponents];

}

#pragma mark - Private UI utility methods
- (void)sayThanksToUser {
    [HSAlertViewController showWithTitle:@"Спасибо, Вы спасли жизнь!"
                                 message:@"Рассчитан интервал до следующей возможной кроводачи"
                       cancelButtonTitle:@"Готово"];
}

- (void)replaceBloodRemoteEvent:(HSBloodRemoteEvent *)oldEvent withEvent:(HSBloodRemoteEvent *)newEvent {
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo: self.navigationController.view animated: YES];
    __weak HSEventPlanningViewController *weakSelf = self;
    [self.calendar replaceBloodRemoteEvent:oldEvent withEvent:newEvent completion: ^(BOOL success, NSError *error) {
        __strong HSEventPlanningViewController *strongSelf = weakSelf;
        [progressHud hide: YES];
        if (success) {
            if ([newEvent isKindOfClass:[HSBloodDonationEvent class]] && newEvent.isDone && !oldEvent.isDone) {
                [strongSelf sayThanksToUser];
            }
            [self.navigationController popToRootViewControllerAnimated: YES];
            [HSFlurryAnalytics userCreatedCalendarEvent:newEvent];
        } else {
            [HSAlertViewController showWithTitle:@"Ошибка" message:[HSModelCommon localizedDescriptionForError:error]];
        }
    }];
}

- (void)addBloodRemoteEvent:(HSBloodRemoteEvent *)event {
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo: self.navigationController.view animated: YES];
    __weak HSEventPlanningViewController *weakSelf = self;
    [self.calendar addBloodRemoteEvent: event completion: ^(BOOL success, NSError *error) {
        __strong HSEventPlanningViewController *strongSelf = weakSelf;
        [progressHud hide: YES];
        if (success) {
            if ([event isKindOfClass:[HSBloodDonationEvent class]] && event.isDone) {
                [strongSelf sayThanksToUser];
            }
            [strongSelf.navigationController popToRootViewControllerAnimated: YES];
            [HSFlurryAnalytics userCreatedCalendarEvent:event];
        } else {
            [HSAlertViewController showWithTitle:@"Ошибка" message:[HSModelCommon localizedDescriptionForError:error]];
        }
    }];
}

- (void)updateUIComponents {
    self.commentsTextView.text = self.currentEditedEvent.comments;
    self.bloodDonationCenterAddressLabel.text = self.currentEditedEvent.labAddress;
    self.bloodDonationEventDateLabel.text = [self.currentEditedEvent formatedScheduleDate];

    self.bloodDonationEventReminderDateLabel.text =
            [HSRemindDatePicker stringFromReminderTimeShift:self.currentEditedEvent.reminderTimeShift];
}


#pragma mark - Private UI action handlers
- (void)donePlanningButtonClicked: (id)sender {
    [self.commentsTextView resignFirstResponder];
    
    NSDate *nowDate = [NSDate date];
    if (self.currentEditedEvent.scheduleDate.timeIntervalSince1970 < nowDate.timeIntervalSince1970) {
        self.currentEditedEvent.isDone = YES;
    } else {
        self.currentEditedEvent.isDone = NO;
    }
    self.currentEditedEvent.comments = self.commentsTextView.text;
    
    HSBloodRemoteEvent *eventToBeReplaced = self.originalBloodDonationEvent != nil ?
            self.originalBloodDonationEvent : self.originalBloodTestsEvent;
    if (eventToBeReplaced != nil) {
        [self replaceBloodRemoteEvent:eventToBeReplaced withEvent:self.currentEditedEvent];
    } else {
        [self addBloodRemoteEvent: self.currentEditedEvent];
    }
}

- (void)cancelPlanningButtonClicked: (id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - Keyboard interaction
- (void)registerKeyboardEventsObserver {
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardWillShow:)
                                                 name: UIKeyboardWillShowNotification object: self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardWillHide:)
                                                 name: UIKeyboardWillHideNotification object: self.view.window];
    
    self.isKeyboardShown = NO;
}

- (void)unregisterKeyboardEventListener {
    [[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardWillShowNotification object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardWillHideNotification object: nil];
    self.isKeyboardShown = NO;
}

- (void)keyboardWillShow: (NSNotification *)notification {
    if (self.isKeyboardShown) {
        return;
    }
    
    NSDictionary* userInfo = [notification userInfo];
    
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    CGRect viewFrame = self.rootScrollView.frame;
    
    viewFrame.size.height -= (keyboardSize.height - kTabBarHeight);
    
    [UIView animateWithDuration: kViewShiftedByKeyboardDuration animations: ^{
        self.rootScrollView.frame = viewFrame;
        [self.rootScrollView scrollRectToVisible: self.commentsTextView.frame animated: YES];
    }];
    self.isKeyboardShown = YES;
}
- (void)keyboardWillHide: (NSNotification *)notification {
    if (!self.isKeyboardShown) {
        return;
    }
    
    NSDictionary* userInfo = [notification userInfo];
    
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect viewFrame = self.rootScrollView.frame;
    
    viewFrame.size.height += (keyboardSize.height - kTabBarHeight);
    
    [UIView animateWithDuration: kViewShiftedByKeyboardDuration animations: ^{
        [self.rootScrollView setFrame: viewFrame];
    }];
    self.isKeyboardShown = NO;
}

#pragma mark - Utility
- (NSDate *)calculateFirstAvailableDateForPlanning {
    NSCalendar *systemCalendar = [NSCalendar currentCalendar];
    NSDateComponents *firstYearDayComponets =
            [systemCalendar components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                              fromDate: [NSDate date]];
    
    firstYearDayComponets.month = 1;
    firstYearDayComponets.day = 1;
    
    return [systemCalendar dateFromComponents: firstYearDayComponets];
}

- (NSDate *)calculateLastAvailableDateForPlanning {
    
    NSCalendar *systemCalendar = [NSCalendar currentCalendar];
    NSDateComponents *nextYearLastYearDayComponets =
            [systemCalendar components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                              fromDate: [NSDate date]];
    
    ++nextYearLastYearDayComponets.year;
    nextYearLastYearDayComponets.month = 12;
    nextYearLastYearDayComponets.day = 31;
    
    return [systemCalendar dateFromComponents: nextYearLastYearDayComponets];
}

@end
