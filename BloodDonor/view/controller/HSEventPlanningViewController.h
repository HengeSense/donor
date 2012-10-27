//
//  HSEventPlanningViewController.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 25.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSEventPlanningViewController : UIViewController

/// @name Subviews properties

/**
 * This is container view for elemments specific for blood donation.
 *     It is hidden when blood event type is blood test.
 */
@property (weak, nonatomic) IBOutlet UIView *bloodDonationTypeView;

/**
 * This is container view for common elements for both blood donation types: blood donation and blood test.
 */
@property (weak, nonatomic) IBOutlet UIView *dataAndPlaceView;

/**
 * This is text editor for specifying user comments.
 */
@property (weak, nonatomic) IBOutlet UITextView *commentsTextView;

/// @name Properties for runtime label modifications.

/**
 * Contains text representation of blood donation event type.
 */
@property (weak, nonatomic) IBOutlet UILabel *bloodEventTypeLabel;

/**
 * Contains text representation of blood donation type.
 */
@property (weak, nonatomic) IBOutlet UILabel *bloodDonationTypeLabel;

/**
 * Contains text representation of blood donation event date.
 */
@property (weak, nonatomic) IBOutlet UILabel *boodEventDateLabel;

/**
 * Contains text representation of blood donation center address.
 */
@property (weak, nonatomic) IBOutlet UILabel *bloodDonationCenterAddressLabel;


/// @name User's interaction hadlers

/**
 * Removes edting event from the calendar.
 */
- (IBAction)removeBloodEvent:(id)sender;

/**
 * Chages blood donation type. Current available blood donation type's set: {blood donation, blood test}.
 */
- (IBAction)changeBloodDonationEventType:(id)sender;

/**
 * Shows UI component for selecting blood donation type.
 */
- (IBAction)selectBloodDonationType:(id)sender;

/**
 * Shows UI component for selecting blood donation center.
 */
- (IBAction)selectBloodDonationCenterAddress:(id)sender;

/**
 * Shows UI component for selecting blood donation event date.
 */
- (IBAction)selectBloodDonationEventDate:(id)sender;


@end
