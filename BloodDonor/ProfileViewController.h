//
//  ProfileViewController.h
//  BloodDonor
//
//  Created by Andrey Rebrik on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageBoxViewController.h"

#import "HSCalendarViewController.h"

@interface ProfileViewController : UIViewController <UITextFieldDelegate, MessageBoxDelegate>
{
    IBOutlet UITextField *loginTextField;
    IBOutlet UITextField *passwordTextField;
}

/**
 * This refrence is used to configure HSCalendarViewController object, after successfull login operation.
 */
@property (nonatomic, retain) HSCalendarViewController *calendarViewController;

- (IBAction)authorizationButtonClick:(id)sender;
- (IBAction)registrationButtonClick:(id)sender;
- (IBAction)settingsButtonClick:(id)sender;

@end
