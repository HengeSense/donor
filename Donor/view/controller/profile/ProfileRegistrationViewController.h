//
//  ProfileRegistrationViewController.h
//  BloodDonor
//
//  Created by Andrey Rebrik on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectBloodGroupViewController.h"
#import "ProfileSexSelectViewController.h"
#import "HSCalendarViewController.h"

@interface ProfileRegistrationViewController : UIViewController <UITextFieldDelegate, IBloodGroupListener, ISexListener>
{
    IBOutlet UIButton *sexButton;
    IBOutlet UIButton *bloodGroupButton;
    
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UITextField *passwordConfirmTextField;
    IBOutlet UITextField *nameTextField;
    
    IBOutlet UIView *dataView;
    
    SelectBloodGroupViewController *selectBloodGroupViewController;
    ProfileSexSelectViewController *sexSelectViewController;
}

/**
 * This refrence is used to configure HSCalendarViewController object, after successfull registration.
 */
@property (nonatomic, retain) HSCalendarViewController *calendarViewController;

- (IBAction)cancelButtonClick:(id)sender;
- (IBAction)doneButtonClick:(id)sender;
- (IBAction)sexButtonClick:(id)sender;
- (IBAction)bloodGroupButtonClick:(id)sender;

@end
