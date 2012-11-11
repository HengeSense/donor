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
    UIButton *editButton;
    IBOutlet UIButton *sexButton;
    IBOutlet UIButton *bloodGroupButton;
    
    IBOutlet UITextField *nameTextField;
    IBOutlet UIView *hiddenView;
    IBOutlet UILabel *bloodDonationCountLabel;
    IBOutlet UILabel *nextBloodDonateDateLabel;
    
    SelectBloodGroupViewController *selectBoodGroupViewController;
    ProfileSexSelectViewController *sexSelectViewController;
}

@property (nonatomic, assign) id<HSCalendarInfo> calendarInfoDelegate;

- (IBAction)settingsButtonClick:(id)sender;
- (IBAction)editButtonClick:(id)sender;

- (IBAction)sexButtonClick:(id)sender;
- (IBAction)bloodGroupButtonClick:(id)sender;
- (IBAction)exitButtonClick:(id)sender;

- (void)cancelEditPressed;
@end
