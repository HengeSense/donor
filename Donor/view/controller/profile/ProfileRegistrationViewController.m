//
//  ProfileRegistrationViewController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 12.07.12.
//  Modified by Sergey Seroshtan on 11.01.13.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "ProfileRegistrationViewController.h"
#import "SelectBloodGroupViewController.h"
#import "AppDelegate.h"
#import "Common.h"
#import <Parse/Parse.h>
#import "HSAlertViewController.h"
#import "ProfileDescriptionViewController.h"
#import "HSCalendar.h"
#import "MBProgressHUD.h"
#import "NSString+HSUtils.h"
#import "ChimpKit.h"

@interface ProfileRegistrationViewController () <ChimpKitDelegate>

@property (nonatomic, weak) UITextField *currentEditingTextField;

@end

@implementation ProfileRegistrationViewController

#pragma mark Actions

@synthesize calendarViewController;

- (IBAction)cancelButtonClick:(id)sender
{
    [self hideKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonClick:(id)sender {
    [self hideKeyboard];
    if (![passwordTextField.text isEqual: passwordConfirmTextField.text]) {
        [HSAlertViewController showWithMessage:@"Пароли не совпадают!"];
    } else if ([emailTextField.text isNotEmpty] && [passwordTextField.text isNotEmpty] &&
               [nameTextField.text isNotEmpty]) {
        PFUser *user = [PFUser user];
        user.username = emailTextField.text;
        user.password = passwordTextField.text;
        user.email = emailTextField.text;
        
        [user setObject:[Common getInstance].sex forKey:@"Sex"];
        [user setObject:[Common getInstance].bloodGroup forKey:@"BloodGroup"];
        [user setObject:[Common getInstance].bloodRH forKey:@"BloodRh"];
        [user setObject:nameTextField.text forKey:@"Name"];
        
        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [progressHud hide:YES];
            if (succeeded) {
                [Common getInstance].authenticatedWithFacebook = NO;
                [HSAlertViewController showWithMessage:@"Регистрация завершена."];
                [self loadCalendarEventsAndGoToProfileForUser:[PFUser currentUser]];
                [self registerEmail:user.email];
            } else {
                [HSAlertViewController showWithMessage:localizedDescriptionForParseError(error)];
            }
        }];
    } else {
        [HSAlertViewController showWithMessage:@"Не все поля заполнены!"];
    }
}

- (IBAction)sexButtonClick:(id)sender
{
    [nameTextField resignFirstResponder];
    [sexSelectViewController showModal];
}

- (IBAction)bloodGroupButtonClick:(id)sender
{
    [nameTextField resignFirstResponder];
    [selectBloodGroupViewController showModal];
}

- (void)loadCalendarEventsAndGoToProfileForUser:(PFUser *)user
{
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HSCalendar *calendarModel = [HSCalendar sharedInstance];
    [calendarModel unlockModelWithUser:user];
    [calendarModel pullEventsFromServer:^(BOOL success, NSError *error) {
        [progressHud hide:YES];
        if (success) {
            ProfileDescriptionViewController *controller = [[ProfileDescriptionViewController alloc]
                    initWithNibName:@"ProfileDescriptionViewController" bundle:nil];
            controller.calendarInfoDelegate = calendarModel;
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            [HSAlertViewController showWithTitle:@"Ошибка" message:@"Не удалось загрузить события календаря."];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

#pragma mark SelectBloodGroupDelegate

- (void) bloodGroupChanged:(NSString *)bloodGroup
{
    if (bloodGroup) 
    {
        [bloodGroupButton setTitle:bloodGroup forState:UIControlStateNormal];
        [bloodGroupButton setTitle:bloodGroup forState:UIControlStateHighlighted];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    dataView.center = CGPointMake(dataView.center.x, dataView.center.y + 138);
    [UIView commitAnimations];   
}

#pragma mark ProfileSexSelectDelegate

- (void) sexChanged:(NSString *)selectedSex
{
    if (selectedSex) 
    {
        if ([selectedSex isEqualToString:@"Мужской"])
        {
            [sexButton setTitle:@"муж" forState:UIControlStateNormal];
            [sexButton setTitle:@"муж" forState:UIControlStateHighlighted];
        }
        else
        {
            [sexButton setTitle:@"жен" forState:UIControlStateNormal];
            [sexButton setTitle:@"жен" forState:UIControlStateHighlighted];
        }
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    dataView.center = CGPointMake(dataView.center.x, dataView.center.y + 35);
    [UIView commitAnimations];   
}

#pragma mark TextEditDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 1)
        [Common getInstance].email = textField.text;
    else if (textField.tag == 2)
        [Common getInstance].password = textField.text;
    else if (textField.tag == 4)
    {
        if (textField.text)
            [Common getInstance].name = textField.text;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        
        dataView.center = CGPointMake(dataView.center.x, dataView.center.y + 65);
        [UIView commitAnimations];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentEditingTextField = textField;
    if (textField.tag == 4)
    {   
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];

        dataView.center = CGPointMake(dataView.center.x, dataView.center.y - 65);
        [UIView commitAnimations];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{ 
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    selectBloodGroupViewController = [[SelectBloodGroupViewController alloc] init];
    selectBloodGroupViewController.delegate = self;
    sexSelectViewController = [[ProfileSexSelectViewController alloc] init];
    sexSelectViewController.delegate = self;
    [bloodGroupButton setTitle:@"O(I)RH+" forState:UIControlStateNormal];
    [bloodGroupButton setTitle:@"O(I)RH+" forState:UIControlStateHighlighted];
    [sexButton setTitle:@"муж" forState:UIControlStateNormal];
    [sexButton setTitle:@"муж" forState:UIControlStateHighlighted];
  
    //Private property setting
    [nameTextField setValue:[UIColor colorWithRed:223.0f/255.0f green:141.0f/255.0f blue:75.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [emailTextField setValue:[UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [passwordTextField setValue:[UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [passwordConfirmTextField setValue:[UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
   
    [Common getInstance].bloodGroup = [NSNumber numberWithInt:0];
    [Common getInstance].bloodRH = [NSNumber numberWithInt:0];
    [Common getInstance].sex = [NSNumber numberWithInt:0];
}

- (void)hideKeyboard {
    if (self.currentEditingTextField != nil) {
        [self.currentEditingTextField resignFirstResponder];
        self.currentEditingTextField = nil;
    }
}

#pragma mark - ChimpKit email registration
- (void)registerEmail:(NSString *)email {
    THROW_IF_ARGUMENT_NIL_2(email);
    
    ChimpKit *chimpService = [[ChimpKit alloc] initWithDelegate:self andApiKey:@"9392e150a6a0a5e66d42d2cd56d5d219-us4"];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"63b23fc742" forKey:@"id"];
    [params setValue:email forKey:@"email_address"];
    [params setValue:@"true" forKey:@"double_optin"];
    [params setValue:@"true" forKey:@"update_existing"];
    
    NSMutableDictionary *mergeVars = [NSMutableDictionary dictionary];
    [mergeVars setValue:@"First" forKey:@"FNAME"];
    [mergeVars setValue:@"Last" forKey:@"LNAME"];
    [params setValue:mergeVars forKey:@"merge_vars"];
        
    [chimpService callApiMethod:@"listSubscribe" withParams:params];}

- (void)ckRequestFailed:(NSError *)error {
    NSLog(@"Email registration failed with error %@.", error);
}

- (void)ckRequestSucceeded:(ChimpKit *)ckRequest {
    NSLog(@"Email was successfully added to mailchimp.");
}
@end
