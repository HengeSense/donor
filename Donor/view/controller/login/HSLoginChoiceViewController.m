//
//  HSLoginChoiceViewController.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 09.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSLoginChoiceViewController.h"

#import <Parse/Parse.h>
#import "MBProgressHUD.h"

#import "HSUserInfo.h"
#import "Common.h"
#import "HSProfileRegistrationViewController.h"
#import "HSProfileDescriptionViewController.h"
#import "HSBaseLoginViewController.h"
#import "HSCalendar.h"
#import "HSAlertViewController.h"

#import "HSItsBeta.h"

@interface HSLoginChoiceViewController ()

@end

@implementation HSLoginChoiceViewController

- (void)configureBaseAuthButton {
    [self.baseAuthorizationButton setBackgroundImage:[UIImage imageNamed:@"login_base_auth_button_normal"]
                                            forState:UIControlStateNormal];
    [self.baseAuthorizationButton setBackgroundImage:[UIImage imageNamed:@"login_base_auth_button_pressed"]
                                            forState:UIControlStateHighlighted];
}

- (void)configureRegistrationButton {
    [self.registrationButton setBackgroundImage:[UIImage imageNamed:@"login_registration_button_normal"]
                                                forState:UIControlStateNormal];
    [self.registrationButton setBackgroundImage:[UIImage imageNamed:@"login_registartion_button_pressed"]
                                                forState:UIControlStateHighlighted];
}

- (void)configureFacebookAuthButton {
    [self.facebookAuthorizationButton setBackgroundImage:[UIImage imageNamed:@"login_facebook_auth_button_normal"]
                                                forState:UIControlStateNormal];
    [self.facebookAuthorizationButton setBackgroundImage:[UIImage imageNamed:@"login_facebook_auth_button_pressed"]
                                                forState:UIControlStateHighlighted];
    
    UIImageView *facebookLogoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_facebook_logo"]];
    CGRect facebookLogoViewFrame = facebookLogoView.frame;
    facebookLogoViewFrame.origin.x = 10;
    facebookLogoViewFrame.origin.y =
            (self.facebookAuthorizationButton.bounds.size.height - facebookLogoViewFrame.size.height) / 2;
    facebookLogoView.frame = facebookLogoViewFrame;
    [self.facebookAuthorizationButton addSubview:facebookLogoView];
}

- (void)configureUI {
    self.title = @"Донор";
    [self configureFacebookAuthButton];
    [self configureBaseAuthButton];
    [self configureRegistrationButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
    [self loginStoredUserIfPossible];
}

- (IBAction)baseAuthorizationSelected:(id)sender {
    HSBaseLoginViewController *profileViewController =
            [[HSBaseLoginViewController alloc] initWithNibName:@"HSBaseLoginViewController" bundle:nil];
    [self.navigationController pushViewController:profileViewController animated:YES];
}

- (void)loginWithBaseAuthForFacebookUser:(PFUser *)facebookUser {
    THROW_IF_ARGUMENT_NIL(facebookUser);
    HSBaseLoginViewController *profileViewController = [[HSBaseLoginViewController alloc] initWithNibName:@"HSBaseLoginViewController" bundle:nil];
    profileViewController.facebookUser = facebookUser;
    [self.navigationController pushViewController:profileViewController animated:YES];
}

- (IBAction)facebookAuthenticationSelected:(id)sender {
    NSArray *permissionsArray = @[@"user_about_me", @"email"];
    
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo: self.navigationController.view animated: YES];
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (user) {
            if (user.isNew) {
                [self specifyFacebookInfoInfoForUser:user completion:^(BOOL success, NSError *error) {
                    if (success) {
                        [self processAuthorizationSuccessWithUser:user completion:^{
                            [HSItsBeta assignItsBeta:self user:user completion:^(NSError *error) {
                                [Common getInstance].authenticatedWithFacebook = YES;
                                [progressHud hide:YES];
                            }];
                        }];
                    } else {
                        [user deleteEventually];
                        [progressHud hide:YES];
                        if (error.code == kPFErrorUserEmailTaken) {
                            // Possible user has base account?
                            [HSAlertViewController showWithTitle:@"Вы уже зарегестрированы" message:@"Ввести пароль?"
                                    cancelButtonTitle:@"Отмена" okButtonTitle:@"Перейти"
                                    resultBlock:^(BOOL isOkButtonPressed) {
                                if (isOkButtonPressed) {
                                    [self loginWithBaseAuthForFacebookUser:user];
                                }
                            }];
                        } else {
                            [self processAuthorizationWithError:error];
                        }
                    }
                }];
            } else {
                [self processAuthorizationSuccessWithUser:user completion: ^ {
                    [HSItsBeta restoreItsBeta:self user:user completion:^(NSError *error) {
                        [progressHud hide:YES];
                    }];
                }];
            }
        } else {
            [self processAuthorizationWithError:error];
            [progressHud hide:YES];
        }
    }];
}

- (IBAction)registrationSelected:(id)sender {
    HSProfileRegistrationViewController *controller = [[HSProfileRegistrationViewController alloc] initWithNibName:@"HSProfileRegistrationViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Private utility methods
- (void)loginStoredUserIfPossible {
    if ([PFUser currentUser]) {
        if ([Common getInstance].authenticatedWithFacebook  &&
                ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            return;
        }
        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        HSCalendar *calendarModel = [HSCalendar sharedInstance];
        [calendarModel unlockModelWithUser:[PFUser currentUser]];
        [calendarModel pullEventsFromServer:^(BOOL success, NSError *error) {
            [progressHud hide:YES];
            if (success == YES) {
                HSProfileDescriptionViewController *controller = [[HSProfileDescriptionViewController alloc] initWithNibName:@"HSProfileDescriptionViewController" bundle:nil];
                controller.calendarInfoDelegate = calendarModel;
                [self.navigationController pushViewController:controller animated:YES];
            } else {
                [HSAlertViewController showWithMessage:@"Ошибка при загрузке событий календаря"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}

- (void)specifyFacebookInfoInfoForUser:(PFUser *)user completion:(void(^)(BOOL success, NSError *error))completion {
    NSString *infoRequestPath = @"me/?fields=first_name,last_name,email,gender";
    [self specifyPlatformInfoForUser:user];
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
            
            HSUserInfo *userInfo = [[HSUserInfo alloc] initWithUser:user];
            userInfo.email = email;
            userInfo.name = firstName;
            userInfo.secondName = secondName;
            userInfo.sex = isMale ? HSSexType_Mail : HSSexType_Femail;
            [userInfo applyChanges];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                completion(succeeded, error);
            }];
        } else {
            completion(NO, error);
        }
    }];
}

@end
