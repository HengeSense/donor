//
//  HSProfileRegistrationViewController.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 30.03.13.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSProfileRegistrationViewController.h"

#import <Parse/Parse.h>
#import "MBProgressHUD.h"

#import "Common.h"
#import "HSCalendar.h"
#import "HSUserInfo.h"
#import "HSMailChimp.h"

#import "HSSexPicker.h"
#import "HSBloodTypePicker.h"
#import "HSProfileDescriptionViewController.h"
#import "HSAlertViewController.h"

#import "NSString+HSUtils.h"

@interface HSProfileRegistrationViewController () <UITextFieldDelegate>

@property (nonatomic, weak) UITextField *currentEditingTextField;
@property (nonatomic, strong) HSBloodTypePicker *bloodTypePicker;
@property (nonatomic, strong) HSSexPicker *sexPicker;

/// This property is used to handle date that user specifies during registration
@property (nonatomic, strong) HSUserInfo *userInfo;

@end

@implementation HSProfileRegistrationViewController

#pragma mark Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bloodTypePicker = [[HSBloodTypePicker alloc] init];
    self.sexPicker = [[HSSexPicker alloc] init];
    self.userInfo = [[HSUserInfo alloc] initWithUser:[PFUser user]];
    
    [self configureNavigationBar];
    [self configureContentView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUIComponents];
}

#pragma mark Actions
- (IBAction)cancelButtonClick:(id)sender {
    [self hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonClick:(id)sender {
    [self hideKeyboard];
    if (![self.passwordTextField.text isEqual: self.passwordConfirmTextField.text]) {
        [HSAlertViewController showWithMessage:@"Пароли не совпадают!"];
    } else if ([self.emailTextField.text isNotEmpty] && [self.passwordTextField.text isNotEmpty] &&
               [self.nameTextField.text isNotEmpty]) {
        PFUser *user = self.userInfo.user;
        user.username = self.emailTextField.text;
        user.password = self.passwordTextField.text;
        
        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [self.userInfo applyChanges];
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [progressHud hide:YES];
            if (succeeded) {
                [Common getInstance].authenticatedWithFacebook = NO;
                [[HSMailChimp sharedInstance] subscribeOrUpdateUser:user];
                [HSAlertViewController showWithMessage:@"Регистрация завершена."];
                [self loadCalendarEventsAndGoToProfileForUser:[PFUser currentUser]];
            } else {
                [HSAlertViewController showWithMessage:[HSModelCommon localizedDescriptionForParseError:error]];
            }
        }];
    } else {
        [HSAlertViewController showWithMessage:@"Не все поля заполнены!"];
    }
}

- (IBAction)sexButtonClick:(id)sender
{
    [self.currentEditingTextField resignFirstResponder];
    [self.sexPicker showWithSex:self.userInfo.sex completion:^(BOOL isDone) {
        if (isDone) {
            self.userInfo.sex = self.sexPicker.sex;
            [self updateSexButtonWithSex:self.userInfo.sex];
        }
    }];
}

- (IBAction)bloodGroupButtonClick:(id)sender
{
    [self.currentEditingTextField resignFirstResponder];
    [self.bloodTypePicker showWithBloodGroup:self.userInfo.bloodGroup bloodRh:self.userInfo.bloodRh
            completion:^(BOOL isDone)
    {
        if (isDone) {
            self.userInfo.bloodGroup = self.bloodTypePicker.bloodGroup;
            self.userInfo.bloodRh = self.bloodTypePicker.bloodRh;
            [self updateBloodTypeButtonWithBloodGroup:self.userInfo.bloodGroup bloodRh:self.userInfo.bloodRh];
        }
    }];
}

- (void)loadCalendarEventsAndGoToProfileForUser:(PFUser *)user
{
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HSCalendar *calendarModel = [HSCalendar sharedInstance];
    [calendarModel unlockModelWithUser:user];
    [calendarModel pullEventsFromServer:^(BOOL success, NSError *error) {
        [progressHud hide:YES];
        if (success) {
            HSProfileDescriptionViewController *controller = [[HSProfileDescriptionViewController alloc]
                    initWithNibName:@"HSProfileDescriptionViewController" bundle:nil];
            controller.calendarInfoDelegate = calendarModel;
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            [HSAlertViewController showWithTitle:@"Ошибка" message:@"Не удалось загрузить события календаря."];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.currentEditingTextField = nil;
    if (textField == self.nameTextField) {
        self.userInfo.name = self.nameTextField.text;
    } else if (textField == self.emailTextField) {
        self.userInfo.email = self.emailTextField.text;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentEditingTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)hideKeyboard {
    if (self.currentEditingTextField != nil) {
        [self.currentEditingTextField resignFirstResponder];
        self.currentEditingTextField = nil;
    }
}

#pragma mark - Private
#pragma mark - UI configuration
- (void)configureNavigationBar {
    self.title = @"Регистрация";

    UIImage *barImageNormal = [UIImage imageNamed:@"barButtonNormal"];
    UIImage *barImagePressed = [UIImage imageNamed:@"barButtonPressed"];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect cancelButtonFrame = CGRectMake(0, 0, barImageNormal.size.width, barImageNormal.size.height);
    [cancelButton setBackgroundImage:barImageNormal forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:barImagePressed forState:UIControlStateHighlighted];
    [cancelButton setTitle:@"Отмена" forState:UIControlStateNormal];
    [cancelButton setTitle:@"Отмена" forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    cancelButton.frame = cancelButtonFrame;
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    [cancelBarButtonItem setTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect doneButtonFrame = CGRectMake(0, 0, barImageNormal.size.width, barImageNormal.size.height);
    [doneButton setBackgroundImage:barImageNormal forState:UIControlStateNormal];
    [doneButton setBackgroundImage:barImagePressed forState:UIControlStateHighlighted];
    [doneButton setTitle:@"Готово" forState:UIControlStateNormal];
    [doneButton setTitle:@"Готово" forState:UIControlStateHighlighted];
    doneButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    doneButton.frame = doneButtonFrame;
    [doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    [doneBarButtonItem setTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = doneBarButtonItem;
}

- (void)configureContentView {  
    //Private property setting
    [self.nameTextField setValue:[UIColor colorWithRed:223.0f/255 green:141.0f/255 blue:75.0f/255 alpha:1]
            forKeyPath:@"_placeholderLabel.textColor"];
    [self.emailTextField setValue:[UIColor colorWithRed:203.0f/255 green:178.0f/255 blue:163.0f/255 alpha:1]
            forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordTextField setValue:[UIColor colorWithRed:203.0f/255 green:178.0f/255 blue:163.0f/255 alpha:1]
            forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordConfirmTextField setValue:[UIColor colorWithRed:203.0f/255 green:178.0f/255 blue:163.0f/255 alpha:1]
            forKeyPath:@"_placeholderLabel.textColor"];
}

#pragma mark - UI updating
- (void)updateUIComponents {
    [self updateBloodTypeButtonWithBloodGroup:HSBloodGroupType_O bloodRh:HSBloodRhType_Positive];
    [self updateSexButtonWithSex:HSSexType_Mail];
}

- (void)updateBloodTypeButtonWithBloodGroup:(HSBloodGroupType)bloodGroup bloodRh:(HSBloodRhType)bloodRh {
    NSString *bloodGroupButtonTitle = [bloodGroupToString(bloodGroup) stringByAppendingString:bloodRhToString(bloodRh)];
    [self.bloodGroupButton setTitle:bloodGroupButtonTitle forState:UIControlStateNormal];
    [self.bloodGroupButton setTitle:bloodGroupButtonTitle forState:UIControlStateHighlighted];
}

- (void)updateSexButtonWithSex:(HSSexType)sex {
    NSString *sexButtonTitle = sexToShortString(sex);
    [self.sexButton setTitle:sexButtonTitle forState:UIControlStateNormal];
    [self.sexButton setTitle:sexButtonTitle forState:UIControlStateHighlighted];
}

@end
