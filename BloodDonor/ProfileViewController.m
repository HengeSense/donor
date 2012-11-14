//
//  ProfileViewController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileDescriptionViewController.h"
#import "ProfileRegistrationViewController.h"
#import "ProfileSettingsViewController.h"
#import <Parse/Parse.h>
#import "Common.h"
#import "MBProgressHUD.h"

#import "HSCalendar.h"

@implementation ProfileViewController

@synthesize calendarViewController;

#pragma mark Actions
- (IBAction)authorizationButtonClick:(id)sender
{
    if (loginTextField.isFirstResponder)
        [loginTextField resignFirstResponder];
    else if (passwordTextField.isFirstResponder)
        [passwordTextField resignFirstResponder];
    
    if ([loginTextField.text isEqualToString:@""]|| [passwordTextField.text isEqualToString:@""])
    {
        MessageBoxViewController *messageBox = [[MessageBoxViewController alloc] initWithNibName:@"MessageBoxViewController"
                                                                                          bundle:nil
                                                                                           title:nil
                                                                                         message:@"Введите логин и пароль"
                                                                                    cancelButton:@"Ок"
                                                                                        okButton:nil];
        messageBox.delegate = self;
        [self.navigationController.tabBarController.view addSubview:messageBox.view];
        
    }
    else
    {
        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo: self.navigationController.view animated: YES];
        [PFUser logInWithUsernameInBackground:loginTextField.text password:passwordTextField.text 
        block:^(PFUser *user, NSError *error) {
            if (user)
            {
                [Common getInstance].email = loginTextField.text;
                [Common getInstance].password = passwordTextField.text;
                [Common getInstance].name = [user objectForKey:@"Name"];
                [Common getInstance].bloodGroup = [user objectForKey:@"BloodGroup"];
                [Common getInstance].bloodRH = [user objectForKey:@"BloodRh"];
                [Common getInstance].sex = [user objectForKey:@"Sex"];

                HSCalendar *calendarModel = [[HSCalendar alloc] init];
                self.calendarViewController.calendarModel = calendarModel;
                [calendarModel pullEventsFromServer:^(BOOL success, NSError *error) {
                    [progressHud hide: YES];
                    if (success) {
                        ProfileDescriptionViewController *controller = [[[ProfileDescriptionViewController alloc]
                                initWithNibName:@"ProfileDescriptionViewController" bundle:nil] autorelease];
                        controller.calendarInfoDelegate = calendarModel;
                        [self.navigationController pushViewController:controller animated:YES];
                    } else {
                        MessageBoxViewController *messageBox = [[MessageBoxViewController alloc]
                                initWithNibName:@"MessageBoxViewController" bundle:nil title:nil
                                message:@"Ошибка при загрузке событий календаря" cancelButton:@"Ок" okButton:nil];
                        messageBox.delegate = self;
                        [self.view addSubview:messageBox.view];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }];
            }
            else
            {
                [progressHud hide: YES];
                NSString *errorString;
                NSInteger errorCode = [[[error userInfo] objectForKey:@"code"] intValue];
                
                if (errorCode == 100)
                    errorString = @"Отсутсвует соединение с интернетом";
                else if (errorCode == 101)
                    errorString = @"Неверный логин или пароль";
                else
                    errorString = @"Ошибка соединения с сервером";
                
                MessageBoxViewController *messageBox = [[MessageBoxViewController alloc]
                        initWithNibName:@"MessageBoxViewController" bundle:nil title:nil message:errorString
                        cancelButton:@"Ок" okButton:nil];
                messageBox.delegate = self;
                [self.navigationController.tabBarController.view addSubview:messageBox.view];
            }
        }];
    }
   
}

- (IBAction)registrationButtonClick:(id)sender
{
    ProfileRegistrationViewController *controller = [[[ProfileRegistrationViewController alloc] initWithNibName:@"ProfileRegistrationViewController" bundle:nil] autorelease];
    controller.calendarViewController = self.calendarViewController;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)settingsButtonClick:(id)sender
{
    ProfileSettingsViewController *controller = [[[ProfileSettingsViewController alloc] initWithNibName:@"ProfileSettingsViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma  mark MessageBoxDelegate

- (void)messageBoxResult:(BOOL)result controller:(MessageBoxViewController *)controller message:(NSString *)message
{
    [controller release];
}

#pragma mark TextEditDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Профиль";
    
    self.navigationItem.backBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil] autorelease];
    
    if ([PFUser currentUser])
    {
        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        HSCalendar *calendarModel = [[HSCalendar alloc] init];
        self.calendarViewController.calendarModel = calendarModel;
        [calendarModel pullEventsFromServer:^(BOOL success, NSError *error) {
            [progressHud hide:YES];
            if (success) {
                ProfileDescriptionViewController *controller = [[[ProfileDescriptionViewController alloc]
                        initWithNibName:@"ProfileDescriptionViewController" bundle:nil] autorelease];
                controller.calendarInfoDelegate = calendarModel;
                [self.navigationController pushViewController:controller animated:YES];
            } else {
                MessageBoxViewController *messageBox = [[MessageBoxViewController alloc]
                        initWithNibName:@"MessageBoxViewController" bundle:nil title:nil
                        message:@"Ошибка при загрузке событий календаря" cancelButton:@"Ок" okButton:nil];
                messageBox.delegate = self;
                [self.view addSubview:messageBox.view];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    
    //Приватное свойство!
    [loginTextField setValue:[UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [passwordTextField setValue:[UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    loginTextField.text = @"";
    passwordTextField.text = @"";
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
