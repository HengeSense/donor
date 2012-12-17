//
//  ProfileViewController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 12.07.12.
//  Updated by SergeySeroshtan on 25.11.12.
//  Copyright (c) 2012 HintSolutions. All rights reserved.
//

#import "ProfileViewController.h"

#import <Parse/Parse.h>
#import "HSFlurryAnalytics.h"

#import "ProfileDescriptionViewController.h"
#import "ProfileRegistrationViewController.h"
#import "ProfileSettingsViewController.h"
#import "Common.h"
#import "MBProgressHUD.h"

#import "HSCalendar.h"

@implementation ProfileViewController

@synthesize calendarViewController;

#pragma mark Actions

- (void)processAuthorizationSuccessWithUser:(PFUser *)user completion: (void(^)(void))completion {
    if (user.isNew) {
        [HSFlurryAnalytics userRegistered];
    }
    [HSFlurryAnalytics userLoggedIn];
    [Common getInstance].email = [user objectForKey:@"email"];
    [Common getInstance].password = passwordTextField.text;
    [Common getInstance].name = [user objectForKey:@"Name"];
    [Common getInstance].bloodGroup = [user objectForKey:@"BloodGroup"];
    [Common getInstance].bloodRH = [user objectForKey:@"BloodRh"];
    [Common getInstance].sex = [user objectForKey:@"Sex"];
    
    HSCalendar *calendarModel = [[HSCalendar alloc] init];
    self.calendarViewController.calendarModel = calendarModel;
    [calendarModel pullEventsFromServer:^(BOOL success, NSError *error) {
        completion();
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

- (void)processAuthorizationWithError: (NSError *)error {
    NSString *errorString = nil;
    NSInteger errorCode = [[[error userInfo] objectForKey:@"code"] intValue];
    
    if (errorCode == 100) {
        errorString = @"Отсутсвует соединение с интернетом";
    }
    else if (errorCode == 101) {
        errorString = @"Неверный логин или пароль";
    }
    else {
        errorString = @"Ошибка соединения с сервером";
    }
    
    MessageBoxViewController *messageBox = [[MessageBoxViewController alloc]
            initWithNibName:@"MessageBoxViewController" bundle:nil title:nil message:errorString
            cancelButton:@"Ок" okButton:nil];
    messageBox.delegate = self;
    [self.navigationController.tabBarController.view addSubview:messageBox.view];
}

- (IBAction)authorizationButtonClick:(id)sender
{
    if (loginTextField.isFirstResponder) {
        [loginTextField resignFirstResponder];
    } else if (passwordTextField.isFirstResponder) {
        [passwordTextField resignFirstResponder];
    }
    
    if ([loginTextField.text isEqualToString:@""]|| [passwordTextField.text isEqualToString:@""]) {
        MessageBoxViewController *messageBox = [[MessageBoxViewController alloc]
                initWithNibName:@"MessageBoxViewController" bundle:nil title:nil message:@"Введите логин и пароль"
                cancelButton:@"Ок" okButton:nil];
        messageBox.delegate = self;
        [self.navigationController.tabBarController.view addSubview:messageBox.view];
        
    } else {
        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo: self.navigationController.view animated: YES];
        [PFUser logInWithUsernameInBackground:loginTextField.text password:passwordTextField.text
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

- (IBAction)facebookAuthorizationButtonClick:(id)sender {
    NSArray *permissionsArray = @[@"user_about_me", @"email"];
    
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo: self.navigationController.view animated: YES];
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (user) {
            [self specifyPlatformInfoForUser:user];
            [self specifyFacebookInfoInfoForUser:user completion:^(BOOL success, NSError *error) {
                if (!success) {
                    [progressHud hide:YES];
                    [self processAuthorizationWithError:error];
                }
                [user saveInBackground];
                [self processAuthorizationSuccessWithUser:user completion: ^ {
                    [Common getInstance].authenticatedWithFacebook = YES;
                    [progressHud hide:YES];
                }];
            }];
        } else {
            [progressHud hide:YES];
            [self processAuthorizationWithError: error];
        }
    }];
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

- (void)configureUI
{
    self.title = @"Профиль";
    
    self.navigationItem.backBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@"Назад"
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil] autorelease];
    
    //Приватное свойство!
    [loginTextField setValue:[UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [passwordTextField setValue:[UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.facebookAuthorizationButton setImage:[UIImage imageNamed:@"facebook_login_button_normal"]
                                      forState:UIControlStateNormal];
    [self.facebookAuthorizationButton setImage:[UIImage imageNamed:@"facebook_login_button_pressed"]
                                      forState:UIControlStateHighlighted];
}

- (void)loginStoredUserIfPossible {
    if ([PFUser currentUser]) {
        if ([Common getInstance].authenticatedWithFacebook  &&
                ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            return;
        }
        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        if ([Common getInstance].authenticatedWithFacebook) {
            [self specifyFacebookInfoInfoForUser:[PFUser currentUser] completion:^(BOOL success, NSError *error) {
                if (!success) {
                    [progressHud hide:YES];
                    NSLog(@"%@", error);
                    NSString *authError = error.userInfo[PF_FBErrorParsedJSONResponseKey][@"body"][@"error"][@"type"];
                    if ([authError isEqualToString:@"OAuthException"]) {
                        [PFUser logOut];
                    }
                    return;
                }
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
            }];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
    [self loginStoredUserIfPossible];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    loginTextField.text = @"";
    passwordTextField.text = @"";
}

#pragma mark - Private utility methods
- (void)specifyPlatformInfoForUser:(PFUser *)user {
    [user setObject:@"iphone" forKey:@"platform"];
}

- (void)specifyFacebookInfoInfoForUser:(PFUser *)user completion:(void(^)(BOOL success, NSError *error))completion {
    NSString *infoRequestPath = @"me/?fields=first_name,last_name,email,gender";
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    PF_FBRequest *infoRequest = [PF_FBRequest requestForGraphPath:infoRequestPath];
    [infoRequest startWithCompletionHandler:^(PF_FBRequestConnection *connection, id result, NSError *error) {
        [progressHud hide:YES];
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result;
            NSString *firstName = userData[@"first_name"];
            NSString *secondName = userData[@"last_name"];
            NSString *email = userData[@"email"];
            NSString *gender = userData[@"gender"];
            BOOL isMale = [gender isEqualToString:@"male"];
            
            [user setObject:email forKey:@"email"];
            [user setObject:firstName forKey:@"Name"];
            [user setObject:secondName forKey:@"secondName"];
            [user setObject:[NSNumber numberWithInteger: isMale ? 0 : 1]  forKey:@"Sex"];
            completion(YES, nil);
        } else {
            completion(NO, error);
        }
    }];
}
- (void)viewDidUnload {
    [self setFacebookAuthorizationButton:nil];
    [super viewDidUnload];
}
@end
