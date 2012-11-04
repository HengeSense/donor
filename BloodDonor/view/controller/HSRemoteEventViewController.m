//
//  HSRemoteEventViewController.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 04.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSRemoteEventViewController.h"
#import "HSEventPlanningViewController.h"

@interface HSRemoteEventViewController ()

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

@implementation HSRemoteEventViewController

#pragma mark - Initialization methods
- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil calendar: (HSCalendar *)calendar
        bloodDonationEvent: (HSBloodDonationEvent *)bloodDonationEvent {
    THROW_IF_ARGUMENT_NIL(calendar, @"calendar is not specified");
    THROW_IF_ARGUMENT_NIL(bloodDonationEvent, @"bloodDonationEvent is not specified");
    return [self initWithNibNameInternal: nibNameOrNil bundle: nibBundleOrNil calendar: calendar
                      bloodDonationEvent: bloodDonationEvent bloodTestsEvent: nil];
}

- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil calendar: (HSCalendar *)calendar
        bloodTestsEvent: (HSBloodTestsEvent *)bloodTestsEvent {
    THROW_IF_ARGUMENT_NIL(calendar, @"calendar is not specified");
    THROW_IF_ARGUMENT_NIL(bloodTestsEvent, @"bloodTestsEvent is not specified");
    return [self initWithNibNameInternal: nibNameOrNil bundle: nibBundleOrNil calendar: calendar
            bloodDonationEvent: nil bloodTestsEvent:bloodTestsEvent];
}

- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil calendar: (HSCalendar *)calendar
        bloodDonationEvent: (HSBloodDonationEvent *)bloodDonationEvent
        bloodTestsEvent: (HSBloodTestsEvent *)bloodTestsEvent {
    THROW_IF_ARGUMENT_NIL(calendar, @"calendar is not specified");
    THROW_IF_ARGUMENT_NIL(bloodDonationEvent, @"bloodDonationEvent is not specified");
    THROW_IF_ARGUMENT_NIL(bloodTestsEvent, @"bloodTestsEvent is not specified");
    return [self initWithNibNameInternal: nibNameOrNil bundle: nibBundleOrNil calendar: calendar
            bloodDonationEvent: bloodDonationEvent bloodTestsEvent: bloodTestsEvent];
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
    [self setLabAddressLabel:nil];
    [self setBloodDonationTypeLabel:nil];
    [self setBloodDonationDateLabel:nil];
    [self setBloodDonationCommentLabel:nil];
    [self setBloodTestsDateLabel:nil];
    [self setBloodTestsLabAdressLabel:nil];
    [self setBloodTestsCommentsLabel:nil];
    [self setBloodTestsView:nil];
    [super viewDidUnload];
}

#pragma mark - UI action handlers
- (IBAction)eventDoneButtonClicked:(id)sender {
}

#pragma mark - Private methods
#pragma mark - Private initialization method
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
    CGPoint bloodTestsViewOriginal = CGPointMake(0.0f, 0.0f);
    CGSize rootScrollViewContentSize = CGSizeMake(self.rootScrollView.bounds.size.width, 0.0f);
    if (self.bloodDonationEvent != nil) {
        // Display view for blood donation event.
        CGSize bloodDonationSize = self.bloodDonationView.bounds.size;
        self.bloodDonationView.frame = CGRectMake(0.0f, 0.0f, bloodDonationSize.width, bloodDonationSize.height);
        self.bloodDonationTypeLabel.text = bloodDonationTypeToString(self.bloodDonationEvent.bloodDonationType);
        self.bloodDonationDateLabel.text = [self.bloodDonationEvent formatScheduledDate];
        self.bloodTestsCommentsLabel.text = self.bloodDonationEvent.comments;
        bloodTestsViewOriginal.y += bloodDonationSize.height + 10;
        [self.rootScrollView addSubview: self.bloodDonationView];
        rootScrollViewContentSize.height += bloodTestsViewOriginal.y;
    }
    
    if (self.bloodTestsEvent != nil) {
        // Display view for blood tests event.
        CGSize bloodTestsSize = self.bloodTestsView.bounds.size;
        self.bloodTestsView.frame = CGRectMake(bloodTestsViewOriginal.x, bloodTestsViewOriginal.y,
                                               bloodTestsSize.width, bloodTestsSize.height);
        self.bloodTestsDateLabel.text = [self.bloodTestsEvent formatScheduledDate];
        self.bloodTestsCommentsLabel.text = self.bloodDonationEvent.comments;
        [self.rootScrollView addSubview: self.bloodTestsView];
        rootScrollViewContentSize.height += bloodTestsSize.height;
    }
    
    self.rootScrollView.contentSize = rootScrollViewContentSize;
}

#pragma mark - Private UI action handlers
- (void)editButtonClick: (id)sender {
    NSDate *dateForEditedEvent = self.bloodDonationEvent != nil ? self.bloodDonationEvent.scheduledDate :
                                                                  self.bloodTestsEvent.scheduledDate;
    HSEventPlanningViewController *eventPlanningViewController =
            [[HSEventPlanningViewController alloc] initWithNibName: @"HSEventPlanningViewController" bundle: nil
            calendar: self.calendar date: dateForEditedEvent bloodDonationEvent: self.bloodDonationEvent
            bloodTestEvent: self.bloodTestsEvent];
    
    [self.navigationController pushViewController: eventPlanningViewController animated: YES];
}

@end
