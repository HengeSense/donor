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
#import "MessageBoxViewController.h"

@interface ProfileRegistrationViewController : UIViewController <UITextFieldDelegate, IBloodGroupListener, ISexListener, MessageBoxDelegate>
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

- (IBAction)cancelButtonClick:(id)sender;
- (IBAction)doneButtonClick:(id)sender;
- (IBAction)sexButtonClick:(id)sender;
- (IBAction)bloodGroupButtonClick:(id)sender;

@end
