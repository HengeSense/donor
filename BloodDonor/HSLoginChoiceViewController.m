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

#import "Common.h"
#import "ProfileRegistrationViewController.h"
#import "ProfileDescriptionViewController.h"
#import "HSBaseLoginViewController.h"
#import "HSCalendar.h"
#import "HSAlertViewController.h"

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
    profileViewController.calendarViewController = self.calendarViewController;
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
                        [self processAuthorizationSuccessWithUser:user completion: ^ {
                            [Common getInstance].authenticatedWithFacebook = YES;
                            [progressHud hide:YES];
                        }];
                    } else {
                        [progressHud hide:YES];
                        [self processAuthorizationWithError:error];
                        [user deleteEventually];
                    }
                }];
            } else {
                [self processAuthorizationSuccessWithUser:user completion: ^ {
                    [Common getInstance].authenticatedWithFacebook = YES;
                    [progressHud hide:YES];
                }];
            }
        } else {
            [progressHud hide:YES];
            [self processAuthorizationWithError: error];
        }
    }];
}

- (IBAction)registrationSelected:(id)sender {
    ProfileRegistrationViewController *controller =
            [[ProfileRegistrationViewController alloc] initWithNibName:@"ProfileRegistrationViewController" bundle:nil];
    controller.calendarViewController = self.calendarViewController;
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
        HSCalendar *calendarModel = [[HSCalendar alloc] init];
        self.calendarViewController.calendarModel = calendarModel;
        [calendarModel pullEventsFromServer:^(BOOL success, NSError *error) {
            [progressHud hide:YES];
            if (success) {
                ProfileDescriptionViewController *controller = [[ProfileDescriptionViewController alloc]
                        initWithNibName:@"ProfileDescriptionViewController" bundle:nil];
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
            
            [user setObject:email forKey:@"email"];
            [user setObject:firstName forKey:@"Name"];
            [user setObject:secondName forKey:@"secondName"];
            [user setObject:[NSNumber numberWithInteger: isMale ? 0 : 1]  forKey:@"Sex"];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                completion(succeeded, error);
            }];
        } else {
            completion(NO, error);
        }
    }];
}

- (void)viewDidUnload {
    [self setBaseAuthorizationButton:nil];
    [self setRegistrationButton:nil];
    [super viewDidUnload];
}
@end
