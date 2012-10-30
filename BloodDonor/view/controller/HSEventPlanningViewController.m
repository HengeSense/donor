//
//  HSEventPlanningViewController.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 25.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSEventPlanningViewController.h"

#pragma mark - Private types
typedef enum {
    HSEventPlanningViewControllerMode_BloodDonation = 0,
    HSEventPlanningViewControllerMode_BloodTest
} HSEventPlanningViewControllerMode;

#pragma mark - Private constants
#pragma mark - Animation constants
static const CGFloat kViewAppearanceDuration = 0.5f;
static const CGFloat kViewMovementDuration = 0.5f;

#pragma mark - UI labels constants
static NSString * const kBloodDonationEventTypeLabel_Donation = @"Кроводача";
static NSString * const kBloodDonationEventTypeLabel_Test = @"Анализ";

#pragma mark - Private interface declaration
@interface HSEventPlanningViewController () <UITextViewDelegate>

/**
 * Contains current view controller displaying mode.
 */
@property(nonatomic, assign) HSEventPlanningViewControllerMode currentViewMode;

/**
 * Edited blood donation event.
 */
@property(nonatomic, strong) HSBloodDonationEvent *bloodDonationEvent;

/**
 * Edited blood test event.
 */
@property(nonatomic, strong) HSBloodTestsEvent *bloodTestsEvent;

/**
 * This property stores initial frame of the flexible UI element.
 */
@property(nonatomic, assign) CGRect flexibleViewInitialFrame;

/**
 * Configures view for editing existing blood donation event.
 */
- (void)configureViewForEditingBloodDonationEvent;

/**
 * Configures view for editing existing blood test event.
 */
- (void)configureViewForEditingBloodTestEvent;

@end

#pragma mark - Public and private interface implmentation
@implementation HSEventPlanningViewController

#pragma mark - Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithNibName: nibNameOrNil bundle: nibBundleOrNil bloodDonationEvent: nil bloodTestEvent: nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
        bloodDonationEvent:(HSBloodDonationEvent *)bloodDonationEvent {
    return [self initWithNibName: nibNameOrNil bundle: nibBundleOrNil bloodDonationEvent: bloodDonationEvent
                  bloodTestEvent: nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
        bloodTestEvent:(HSBloodTestsEvent *)bloodTestEvent {
    return [self initWithNibName: nibNameOrNil bundle: nibBundleOrNil bloodDonationEvent: nil
                  bloodTestEvent: bloodTestEvent];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
        bloodDonationEvent:(HSBloodDonationEvent *)bloodDonationEvent
       bloodTestEvent:(HSBloodTestsEvent *)bloodTestEvent {

    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        self.currentViewMode = HSEventPlanningViewControllerMode_BloodDonation;
        self.bloodDonationEvent = bloodDonationEvent;
        self.bloodTestsEvent = bloodTestEvent;
    }
    return self;
}


#pragma mark - UI life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rootScrollView addSubview: self.contentView];
    self.rootScrollView.contentSize = self.contentView.bounds.size;
    self.commentsTextView.backgroundColor = [UIColor colorWithPatternImage:
            [UIImage imageNamed: @"eventCommentBackground.png"]];
    self.flexibleViewInitialFrame = self.dataAndPlaceView.frame;

    if (self.bloodDonationEvent != nil) {
        [self configureViewForEditingBloodDonationEvent];
        if (self.bloodTestsEvent == nil) {
            self.bloodTestsEvent = [[HSBloodTestsEvent alloc] init];
        }
    } else if (self.bloodTestsEvent != nil) {
        [self configureViewForEditingBloodTestEvent];
        if (self.bloodDonationEvent == nil) {
            self.bloodDonationEvent = [[HSBloodDonationEvent alloc] init];
        }
    } else {
        self.bloodDonationEvent = [[HSBloodDonationEvent alloc] init];
        self.bloodTestsEvent = [[HSBloodTestsEvent alloc] init];
        [self configureViewForEditingBloodDonationEvent];
    }
}

- (void)viewDidUnload {
    [self setDataAndPlaceView:nil];
    [self setBloodDonationTypeView:nil];
    [self setCommentsTextView:nil];
    [self setBloodDonationEventTypeLabel:nil];
    [self setBloodDonationTypeLabel:nil];
    [self setBloodDonationEventDateLabel:nil];
    [self setBloodDonationCenterAddressLabel:nil];
    [self setRootScrollView:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}

#pragma mark - User's interaction hadlers
- (IBAction)removeBloodEvent: (id)sender {
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
}

- (IBAction)selectBloodDonationCenterAddress: (id)sender {
}

- (IBAction)selectBloodDonationEventDate: (id)sender {
}

#pragma mark - Private interface implementation
#pragma mark - Configuring HSEventPlanningViewController for different modes
- (void)configureViewForEditingBloodDonationEvent {
    if (self.bloodDonationEvent == nil) {
        [NSException exceptionWithName: NSInternalInconsistencyException
                reason: @"bloodDonationEvent property is not defined" userInfo: nil];
    }
    self.bloodDonationEventTypeLabel.text = kBloodDonationEventTypeLabel_Donation;
    self.bloodDonationEventDateLabel.text =
            [self.bloodDonationEvent.dateFormatter stringFromDate: self.bloodDonationEvent.scheduledDate];
    if (self.bloodDonationTypeView.isHidden || self.bloodDonationTypeView.alpha <= 0.0f) {
        [UIView animateWithDuration: kViewMovementDuration animations:^{
            self.dataAndPlaceView.frame = self.flexibleViewInitialFrame;
            self.bloodDonationTypeView.alpha = 1.0f;
        }];
        self.currentViewMode = HSEventPlanningViewControllerMode_BloodDonation;
    }
}

- (void)configureViewForEditingBloodTestEvent {
    if (self.bloodTestsEvent == nil) {
        [NSException exceptionWithName: NSInternalInconsistencyException
                                reason: @"bloodTestEvent property is not defined" userInfo: nil];
    }
    self.bloodDonationEventTypeLabel.text = kBloodDonationEventTypeLabel_Test;
    self.bloodDonationEventDateLabel.text =
            [self.bloodTestsEvent.dateFormatter stringFromDate: self.bloodTestsEvent.scheduledDate];
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
}

@end
