//
//  HSLoginViewController.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 10.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSBaseLoginViewController.h"

#import <Parse/Parse.h>
#import "HSFlurryAnalytics.h"

#import "ProfileDescriptionViewController.h"
#import "ProfileRegistrationViewController.h"
#import "ProfileSettingsViewController.h"
#import "HSRestorePasswordViewCotroller.h"

#import "Common.h"
#import "MBProgressHUD.h"
#import "HSAlertViewController.h"

#import "HSCalendar.h"

@implementation HSBaseLoginViewController

#pragma mark Lifecycle

- (void)configureBaseAuthButton {
    [self.baseAuthorizationButton setBackgroundImage:[UIImage imageNamed:@"login_base_auth_button_normal"]
                                            forState:UIControlStateNormal];
    [self.baseAuthorizationButton setBackgroundImage:[UIImage imageNamed:@"login_base_auth_button_pressed"]
                                            forState:UIControlStateHighlighted];
}

- (void)configureNavigationBar {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                                                             style:UIBarButtonItemStyleBordered target:nil action:nil];
}

- (void)configureTextFields {
    //Private property setting
    [self.loginTextField setValue:[UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordTextField setValue:[UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)configureUI {
    self.title = @"Профиль";
    [self configureNavigationBar];
    [self configureTextFields];
    [self configureBaseAuthButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
}

- (void)viewDidAppear:(BOOL)animated {
    self.loginTextField.text = @"";
    self.passwordTextField.text = @"";
    [super viewDidAppear:animated];
}

#pragma mark Actions
- (IBAction)authorizationButtonClicked:(id)sender {
    if (self.loginTextField.isFirstResponder) {
        [self.loginTextField resignFirstResponder];
    } else if (self.passwordTextField.isFirstResponder) {
        [self.passwordTextField resignFirstResponder];
    }
    
    if ([self.loginTextField.text isEqualToString:@""]|| [self.passwordTextField.text isEqualToString:@""]) {
        [HSAlertViewController showWithMessage:@"Введите логин и пароль"];
    } else {
        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo: self.navigationController.view animated: YES];
        [PFUser logInWithUsernameInBackground:self.loginTextField.text password:self.passwordTextField.text
        block:^(PFUser *user, NSError *error) {
            if (user) {
                [self specifyPlatformInfoForUser:user];
                [user saveInBackground];
                [self processAuthorizationSuccessWithUser:user completion:^ {
                    [Common getInstance].authenticatedWithFacebook = NO;
                    [progressHud hide:YES];
                }];
            } else {
                [progressHud hide:YES];
                [self processAuthorizationWithError:error];
            }
        }];
    }
   
}

- (IBAction)forgotPasswordButtonClicked:(id)sender {
    HSRestorePasswordViewCotroller *restorePasswordVeiwController =
            [[HSRestorePasswordViewCotroller alloc] initWithNibName:@"HSRestorePasswordViewCotroller" bundle:nil];
    [self.navigationController pushViewController:restorePasswordVeiwController animated:YES];
}

#pragma mark TextEditDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
