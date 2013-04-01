//
//  HSProfileDescriptionViewController.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 30.03.13.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSSexPicker.h"
#import "HSBloodTypePicker.h"

#import "HSCalendarInfo.h"

@interface HSProfileDescriptionViewController : UIViewController <UITextFieldDelegate>

/// @name Common UI properties
@property (weak, nonatomic) UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *sexButton;
@property (weak, nonatomic) IBOutlet UIButton *bloodGroupButton;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIView *hiddenView;
@property (weak, nonatomic) IBOutlet UILabel *bloodDonationCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextBloodDonateDateLabel;


/// @name Facebook UI properties
@property (weak, nonatomic) IBOutlet UIView *facebookContainerView;
@property (weak, nonatomic) IBOutlet UILabel *facebookUserNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *proposeFacebookLinkUnlinkButton;
@property (weak, nonatomic) IBOutlet UIView *facebookLinkUnlinkContainerView;
@property (strong, nonatomic) IBOutlet UIView *linkUnlinkFacebookView;
@property (weak, nonatomic) IBOutlet UIButton *linkUnlinkFacebookButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelFacebookLinkProposeButton;

///  @name Model properties
@property (nonatomic, assign) id<HSCalendarInfo> calendarInfoDelegate;

- (IBAction)editButtonClick:(id)sender;

- (IBAction)sexButtonClick:(id)sender;
- (IBAction)bloodGroupButtonClick:(id)sender;
- (IBAction)logoutButtonClick:(id)sender;
- (IBAction)linkUnlinkToFacebook:(id)sender;
- (IBAction)proposeLinkUnlinkFacebook:(id)sender;
- (IBAction)cancelFacebookLinkingPropose:(id)sender;

- (void)cancelEditPressed;
@end
