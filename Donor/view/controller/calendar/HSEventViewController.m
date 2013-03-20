//
//  HSEventViewController.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 04.11.12.
//  Modified by Sergey Seroshtan on 04.12.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSEventViewController.h"
#import "HSEventPlanningViewController.h"
#import "HSAlertViewController.h"

#import "NSDate+HSCalendar.h"
#import "UIView+HSLayoutManager.h"

@interface HSEventViewController ()

/**
 * Reference to the calendar model.
 */
@property (nonatomic, strong) HSCalendar *calendar;

/**
 * Displayed blood donation event.
 */
@property (nonatomic, strong) HSBloodDonationEvent *bloodDonationEvent;

/**
 * Displayed blood tests event.
 */
@property (nonatomic, strong) HSBloodTestsEvent *bloodTestsEvent;

/**
 * Current displayed blood tests event or blood donation event.
 */
@property (nonatomic, strong) HSBloodRemoteEvent *currentBloodRemoteEvent;

/**
 * Private initialization for displaying blood donation (HSBloodDonationEvent) remote event and
 *     for displaying blood tests (HSBloodTestsEvent) remote event. Does not check input parameters.
 */
- (id)initWithNibNameInternal: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil
        calendar: (HSCalendar *)calendar
        bloodDonationEvent: (HSBloodDonationEvent *)bloodDonationEvent
        bloodTestsEvent: (HSBloodTestsEvent *)bloodTestsEvent;

/// @name UI configuration methods
/**
 * Configures navigation bar view and it's controls.
 */
- (void)configureNavigationBar;

/**
 * Configures view for displaying remote events.
 */
- (void)configureViews;

@end

@implementation HSEventViewController

#pragma mark - Initialization methods
- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil calendar: (HSCalendar *)calendar
        bloodDonationEvent: (HSBloodDonationEvent *)bloodDonationEvent {
    THROW_IF_ARGUMENT_NIL_2(calendar);
    THROW_IF_ARGUMENT_NIL_2(bloodDonationEvent);
    return [self initWithNibNameInternal: nibNameOrNil bundle: nibBundleOrNil calendar: calendar
                      bloodDonationEvent: bloodDonationEvent bloodTestsEvent: nil];
}

- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil calendar: (HSCalendar *)calendar
        bloodTestsEvent: (HSBloodTestsEvent *)bloodTestsEvent {
    THROW_IF_ARGUMENT_NIL_2(calendar);
    THROW_IF_ARGUMENT_NIL_2(bloodTestsEvent);
    return [self initWithNibNameInternal: nibNameOrNil bundle: nibBundleOrNil calendar: calendar
            bloodDonationEvent: nil bloodTestsEvent:bloodTestsEvent];
}

#pragma mark - UI lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBar];
    [self configureViews];
}

- (void)viewDidUnload {
    [self setRootView:nil];
    [self setRootScrollView:nil];
    [self setBloodDonationView:nil];
    [self setBloodDonationLabAddressLabel:nil];
    [self setBloodDonationTypeLabel:nil];
    [self setBloodDonationDateLabel:nil];
    [self setBloodDonationCommentTextView:nil];
    [self setBloodTestsDateLabel:nil];
    [self setBloodTestsLabAddressLabel:nil];
    [self setBloodTestsCommentsTextView:nil];
    [self setBloodTestsView:nil];
    [self setDoneButton:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rootScrollView adjustAsContentView];
}

#pragma mark - UI action handlers
- (IBAction)eventDoneButtonClicked:(id)sender {
    [self markEventAsDone:self.currentBloodRemoteEvent];
}

#pragma mark - Private methods
#pragma mark -Initialization method
- (id)initWithNibNameInternal: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil
        calendar: (HSCalendar *)calendar
        bloodDonationEvent: (HSBloodDonationEvent *)bloodDonationEvent
        bloodTestsEvent: (HSBloodTestsEvent *)bloodTestsEvent {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        self.calendar = calendar;
        self.bloodDonationEvent = bloodDonationEvent;
        self.bloodTestsEvent = bloodTestsEvent;
    }
    return self;
}

#pragma mark - UI configuration methods
- (void)configureNavigationBar {
    self.title = @"События";
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Назад"
            style: UIBarButtonItemStyleBordered target: nil action:nil];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *barImageNormal = [UIImage imageNamed:@"barButtonNormal"];
    UIImage *barImagePressed = [UIImage imageNamed:@"barButtonPressed"];
    CGRect editButtonFrame = CGRectMake(0, 0, barImageNormal.size.width, barImageNormal.size.height);
    [editButton setBackgroundImage:barImageNormal forState:UIControlStateNormal];
    [editButton setBackgroundImage:barImagePressed forState:UIControlStateHighlighted];
    [editButton setTitle:@"Изменить" forState:UIControlStateNormal];
    [editButton setTitle:@"Изменить" forState:UIControlStateHighlighted];
    editButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    editButton.frame = editButtonFrame;
    [editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    [editBarButtonItem setTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = editBarButtonItem;

}

- (void)configureViews {
    CGSize rootScrollViewContentSize = CGSizeMake(self.rootScrollView.bounds.size.width, 0.0f);
    if (self.bloodDonationEvent != nil) {
        // Display view for blood donation event.
        self.currentBloodRemoteEvent = self.bloodDonationEvent;
        CGSize bloodDonationSize = self.bloodDonationView.bounds.size;
        self.bloodDonationView.frame = CGRectMake(0.0f, 0.0f, bloodDonationSize.width, bloodDonationSize.height);
        self.bloodDonationTypeLabel.text = bloodDonationTypeToString(self.bloodDonationEvent.bloodDonationType);
        self.bloodDonationDateLabel.text = [self.bloodDonationEvent formatedScheduleDate];
        self.bloodDonationLabAddressLabel.text = self.bloodDonationEvent.labAddress;
        self.bloodDonationCommentTextView.text = self.bloodDonationEvent.comments;
        [self.rootScrollView addSubview: self.bloodDonationView];
        rootScrollViewContentSize.height += bloodDonationSize.height;
        
        if (self.bloodDonationEvent.scheduleDate.timeIntervalSince1970 > [[NSDate date] timeIntervalSince1970]) {
            self.doneButton.enabled = NO;
        } else {
            self.doneButton.enabled = !self.currentBloodRemoteEvent.isDone;
        }

    } else if (self.bloodTestsEvent != nil) {
        self.currentBloodRemoteEvent = self.bloodTestsEvent;
        // Display view for blood tests event.
        CGSize bloodTestsSize = self.bloodTestsView.bounds.size;
        self.bloodTestsView.frame = CGRectMake(0.0f, 0.0f, bloodTestsSize.width, bloodTestsSize.height);
        self.bloodTestsDateLabel.text = [self.bloodTestsEvent formatedScheduleDate];
        self.bloodTestsCommentsTextView.text = self.bloodTestsEvent.comments;
        self.bloodTestsLabAddressLabel.text = self.bloodTestsEvent.labAddress;
        [self.rootScrollView addSubview: self.bloodTestsView];
        rootScrollViewContentSize.height += bloodTestsSize.height;
    }    
    self.rootScrollView.contentSize = rootScrollViewContentSize;
}

#pragma mark - UI action handlers
- (void)editButtonClick: (id)sender {
    HSEventPlanningViewController *eventPlanningViewController = nil;
    if (self.bloodDonationEvent != nil) {
        eventPlanningViewController = [[HSEventPlanningViewController alloc]
                initWithNibName: @"HSEventPlanningViewController" bundle: nil calendar: self.calendar
                date: self.bloodDonationEvent.scheduleDate bloodDonationEvent: self.bloodDonationEvent];
    } else if (self.bloodTestsEvent != nil) {
        eventPlanningViewController = [[HSEventPlanningViewController alloc]
                initWithNibName: @"HSEventPlanningViewController" bundle: nil calendar: self.calendar
                date: self.bloodTestsEvent.scheduleDate bloodTestsEvent: self.bloodTestsEvent];
    } else {
        @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                       reason: @"HSEventViewController was configured without remote event"
                                     userInfo: nil];
    }
    eventPlanningViewController.title = @"Изменить";
    [self.navigationController pushViewController: eventPlanningViewController animated: YES];
}

#pragma mark - Event processing
- (void)markEventAsDone:(HSBloodRemoteEvent *)remoteEvent {
    THROW_IF_ARGUMENT_NIL_2(remoteEvent);
    if ([remoteEvent.scheduleDate isAfterDay: [NSDate date]]) {
        @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                       reason: @"Was made attempt to mark event from future as done." userInfo: nil];
    }
    remoteEvent.isDone = YES;
    [remoteEvent saveWithCompletionBlock: ^(BOOL success, NSError *error) {
        if (success) {
            [HSAlertViewController showWithTitle:@"Спасибо, Вы спасли жизнь!"
                                         message:@"Рассчитан интервал до следующей возможной кроводачи"
                               cancelButtonTitle:@"Готово"];
            [self.navigationController popToRootViewControllerAnimated: YES];
        } else {
            [HSAlertViewController showWithTitle:@"Ошибка" message:localizedDescriptionForError(error)];
        }
    }];
}


@end
