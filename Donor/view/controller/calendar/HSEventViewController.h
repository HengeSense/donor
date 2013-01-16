//
//  HSEventViewController.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 04.11.12.
//  Modified by Sergey Seroshtan on 04.12.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSBloodDonationEvent.h"
#import "HSBloodTestsEvent.h"
#import "HSCalendar.h"

/**
 * This view controller's aim is to display existing (already planned) remote events.
 */
@interface HSEventViewController : UIViewController

/// @name Outlets properties
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

/// @name Root views
@property (strong, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;

/// @name Blood donation event view and it's components
@property (strong, nonatomic) IBOutlet UIView *bloodDonationView;
@property (weak, nonatomic) IBOutlet UILabel *bloodDonationLabAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *bloodDonationTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bloodDonationDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *bloodDonationCommentTextView;
- (IBAction)eventDoneButtonClicked:(id)sender;

/// @name Blood tests view and it's components
@property (strong, nonatomic) IBOutlet UIView *bloodTestsView;
@property (weak, nonatomic) IBOutlet UILabel *bloodTestsDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bloodTestsLabAddressLabel;
@property (weak, nonatomic) IBOutlet UITextView *bloodTestsCommentsTextView;

/// @name Initialization methods

/**
 * Initialization for displaying blood donation (HSBloodDonationEvent) remote event.
 */
- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil calendar: (HSCalendar *)calendar
        bloodDonationEvent: (HSBloodDonationEvent *)bloodDonationEvent;

/**
 * Initialization for displaying blood tests (HSBloodTestsEvent) remote event.
 */
- (id)initWithNibName: (NSString *)nibNameOrNil bundle: (NSBundle *)nibBundleOrNil calendar: (HSCalendar *)calendar
        bloodTestsEvent: (HSBloodTestsEvent *)bloodTestsEvent;


@end
