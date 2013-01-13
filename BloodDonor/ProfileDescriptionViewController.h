//
//  ProfileDescriptionViewController.h
//  BloodDonor
//
//  Created by Andrey Rebrik on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectBloodGroupViewController.h"
#import "ProfileSexSelectViewController.h"

#import "HSCalendarInfo.h"

@interface ProfileDescriptionViewController : UIViewController <UITextFieldDelegate, IBloodGroupListener, ISexListener>
{
}

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
@property (strong, nonatomic) IBOutlet UIView *unlinkFacebookView;
@property (strong, nonatomic) IBOutlet UIView *linkFacebookView;

///  @name Model properties
@property (nonatomic, assign) id<HSCalendarInfo> calendarInfoDelegate;

@property (nonatomic, retain) SelectBloodGroupViewController *selectBloodGroupViewController;
@property (nonatomic, retain) ProfileSexSelectViewController *sexSelectViewController;

- (IBAction)settingsButtonClick:(id)sender;
- (IBAction)editButtonClick:(id)sender;

- (IBAction)sexButtonClick:(id)sender;
- (IBAction)bloodGroupButtonClick:(id)sender;
- (IBAction)logoutButtonClick:(id)sender;
- (IBAction)linkUnlinkToFacebook:(id)sender;
- (IBAction)proposeLinkUnlinkFacebook:(id)sender;
- (IBAction)cancelFacebookLinkUnlinkActionSheet:(id)sender;

- (void)cancelEditPressed;
@end
