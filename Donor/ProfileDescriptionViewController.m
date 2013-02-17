//
//  ProfileDescriptionViewController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 12.07.12.
//  Updated be Sergey Seroshtan on 29.11.12.
//  Copyright (c) 2012 HintSolutions. All rights reserved.
//

#import "ProfileDescriptionViewController.h"

#import <Parse/Parse.h>
#import "HSFlurryAnalytics.h"
#import "MBProgressHUD.h"

#import "ProfileSettingsViewController.h"
#import "AppDelegate.h"
#import "Common.h"
#import "HSAlertViewController.h"
#import "HSModelCommon.h"
#import "NSString+HSUtils.h"

static const CGFloat kActionSheetAnimationDuration = 0.2;

static NSString * const kNotLinkedToFacebookTitle = @"не привязан";
static NSString * const kLinkedToFacebookTitle = @"привязан";

@interface ProfileDescriptionViewController ()
@property (nonatomic, weak) UIView *currentActionSheet;
@end

@implementation ProfileDescriptionViewController

#pragma mark Actions

- (IBAction)settingsButtonClick:(id)sender {
    ProfileSettingsViewController *controller = [[ProfileSettingsViewController alloc]
            initWithNibName:@"ProfileSettingsViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)cancelEditPressed {
    [self hideCurrentActionSheetView];

    self.hiddenView.hidden = NO;
    self.facebookLinkUnlinkContainerView.hidden = YES;
    [self.editButton setTitle:@"Изменить" forState:UIControlStateNormal];
    [self.editButton setTitle:@"Изменить" forState:UIControlStateHighlighted];
    self.nameTextField.enabled = NO;
    self.nameTextField.textColor = [UIColor colorWithRed:132.0f/255.0f green:113.0f/255.0f blue:104.0f/255.0f alpha:1];
    //Private property setting
    [self.nameTextField setValue:[UIColor colorWithRed:132.0f/255.0f green:113.0f/255.0f blue:104.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    self.sexButton.enabled = NO;
    self.bloodGroupButton.enabled = NO;
    self.navigationItem.leftBarButtonItem = nil;
}

- (IBAction)editButtonClick:(id)sender
{
    if (self.hiddenView.hidden)
    {
        if ([self.nameTextField isFirstResponder]) {
            [self.nameTextField resignFirstResponder];
        }
        
        if ([self.nameTextField.text isNotEmpty]) {
            [Common getInstance].name = self.nameTextField.text;
        } else {
            [HSAlertViewController showWithMessage:@"Имя пользователя не задано."
                resultBlock:^(BOOL isOkButtonPressed) {
                   [self.nameTextField becomeFirstResponder];
            }];
            return;
        }
        [self cancelEditPressed];

        PFUser *user = [PFUser currentUser];
        
        if ([Common getInstance].sex != nil) {
            [user setObject:[Common getInstance].sex forKey:@"Sex"];
        }
        
        if ([Common getInstance].bloodGroup != nil) {
            [user setObject:[Common getInstance].bloodGroup forKey:@"BloodGroup"];
        }
        
        if ([Common getInstance].bloodRH != nil) {
            [user setObject:[Common getInstance].bloodRH forKey:@"BloodRh"];
        }
        
        if ([Common getInstance].name != nil) {
            [user setObject:[Common getInstance].name forKey:@"Name"];
        }
        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [progressHud hide:YES];
            if (succeeded) {
                [HSFlurryAnalytics userUpdatedProfile];
            } else {
                [HSAlertViewController showWithTitle:@"Ошибка" message:localizedDescriptionForParseError(error)];
            }
        }];
    }
    else
    {
        self.hiddenView.hidden = YES;
        [self.editButton setTitle:@"Готово" forState:UIControlStateNormal];
        [self.editButton setTitle:@"Готово" forState:UIControlStateHighlighted];
        self.nameTextField.enabled = YES;
        self.sexButton.enabled = YES;
        self.nameTextField.textColor = [UIColor colorWithRed:223.0f/255.0f green:141.0f/255.0f blue:75.0f/255.0f alpha:1];
        //Private property setting
        [self.nameTextField setValue:[UIColor colorWithRed:223.0f/255.0f green:141.0f/255.0f blue:75.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        self.bloodGroupButton.enabled = YES;
        [Common getInstance].sex = [[PFUser currentUser] valueForKey:@"Sex"];
        [Common getInstance].bloodGroup = [[PFUser currentUser] valueForKey:@"BloodGroup"];
        [Common getInstance].bloodRH = [[PFUser currentUser] valueForKey:@"BloodRh"];
        
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
        [cancelButton addTarget:self action:@selector(cancelEditPressed) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
        [cancelBarButtonItem setTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
        
        if (![Common getInstance].authenticatedWithFacebook) {
            self.facebookLinkUnlinkContainerView.hidden = NO;
        } 
    }
}

- (IBAction)sexButtonClick:(id)sender {
    [self.nameTextField resignFirstResponder];
    [self.sexSelectViewController showModal];
}

- (IBAction)bloodGroupButtonClick:(id)sender {
    [self.nameTextField resignFirstResponder];
    [self.selectBloodGroupViewController showModal];
}

- (IBAction)logoutButtonClick:(id)sender {
    [HSFlurryAnalytics userLoggedOut];
    [PFUser logOut];
    [Common getInstance].email = nil;
    [Common getInstance].name = nil;
    [Common getInstance].password = nil;
    [Common getInstance].events = nil;
    [Common getInstance].bloodGroup = 0;
    [Common getInstance].bloodRH = 0;
    [Common getInstance].sex = 0;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)unlinkFacebook {
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser] block:^(BOOL succeeded, NSError *error) {
        [progressHud hide:YES];
        if (succeeded) {
            [self.proposeFacebookLinkUnlinkButton setTitle:kNotLinkedToFacebookTitle forState:UIControlStateNormal];
        } else {
            [HSAlertViewController showWithTitle:@"Ошибка" message:localizedDescriptionForParseError(error)];
            NSLog(@"Facebook unlink failed due to error: %@", error);
        }
    }];
}

- (void)linkFacebook {
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSArray *permissions = @[@"user_about_me", @"email"];
    [PFFacebookUtils linkUser:[PFUser currentUser] permissions:permissions block:^(BOOL succeeded, NSError *error) {
        [progressHud hide:YES];
        if (succeeded) {
            [self.proposeFacebookLinkUnlinkButton setTitle:kLinkedToFacebookTitle forState:UIControlStateNormal];
        } else {
            [HSAlertViewController showWithTitle:@"Ошибка" message:localizedDescriptionForParseError(error)];
            NSLog(@"Facebook link failed due to error: %@", error);
        }
    }];
}

- (void)showViewAsActionSheet:(UIView *)actionSheetView {
    self.view.userInteractionEnabled = NO;
    if (self.currentActionSheet != nil) {
        [self hideCurrentActionSheetView];
    }
    self.currentActionSheet = actionSheetView;

    
    CGRect invisibleFrame = actionSheetView.frame;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    invisibleFrame.origin.x = 0;
    invisibleFrame.origin.y = screenHeight;
    actionSheetView.frame = invisibleFrame;

    UIWindow* mainWindow = (((AppDelegate*) [UIApplication sharedApplication].delegate).window);
    [mainWindow addSubview:actionSheetView];
    
    [UIView animateWithDuration:kActionSheetAnimationDuration animations:^{
        CGRect visibleFrame = actionSheetView.frame;
        visibleFrame.origin.y = screenHeight - visibleFrame.size.height;
        actionSheetView.frame = visibleFrame;
    }];
}

- (void)hideCurrentActionSheetView {
    if (self.currentActionSheet == nil) {
        return;
    }
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGRect invisibleFrame = self.currentActionSheet.frame;
    invisibleFrame.origin.y = screenHeight;
    [UIView animateWithDuration:kActionSheetAnimationDuration animations:^{
        self.currentActionSheet.frame = invisibleFrame;
    } completion:^(BOOL finished) {
        [self.currentActionSheet removeFromSuperview];
    }];
    self.currentActionSheet = nil;
    self.view.userInteractionEnabled = YES;
}

- (void)proposeUserLinkFacebook {
    [self.linkUnlinkFacebookButton setTitle:@"Привязать" forState:UIControlStateNormal];
    [self showViewAsActionSheet:self.linkUnlinkFacebookView];
}

- (void)proposeUserUnlinkFacebook {
    [self.linkUnlinkFacebookButton setTitle:@"Отвязать" forState:UIControlStateNormal];
    [self showViewAsActionSheet:self.linkUnlinkFacebookView];
}

- (IBAction)cancelFacebookLinkingPropose:(id)sender {
    [self hideCurrentActionSheetView];
}

- (IBAction)linkUnlinkToFacebook:(id)sender {
    [self cancelFacebookLinkingPropose:sender];
    if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self unlinkFacebook];
    } else {
        [self linkFacebook];
    }
}

- (IBAction)proposeLinkUnlinkFacebook:(id)sender {
    if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self proposeUserUnlinkFacebook];
    } else {
        [self proposeUserLinkFacebook];
    }
}

#pragma mark SelectBloodGroupDelegate

- (void) bloodGroupChanged:(NSString *)bloodGroup
{
    if (bloodGroup) 
    {
        [self.bloodGroupButton setTitle:bloodGroup forState:UIControlStateNormal];
        [self.bloodGroupButton setTitle:bloodGroup forState:UIControlStateHighlighted];
    }
}

#pragma mark ProfileSexSelectDelegate

- (void) sexChanged:(NSString *)selectedSex
{
    if (selectedSex) 
    {
        if ([selectedSex isEqualToString:@"Мужской"])
        {
            [self.sexButton setTitle:@"муж" forState:UIControlStateNormal];
            [self.sexButton setTitle:@"муж" forState:UIControlStateHighlighted];
        }
        else
        {
            [self.sexButton setTitle:@"жен" forState:UIControlStateNormal];
            [self.sexButton setTitle:@"жен" forState:UIControlStateHighlighted];
        }
    }
}

#pragma mark TextEditDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Lifecycle
- (void)configureFacebookUI {
    // Configure facebook link/unlink container view controller.
    self.facebookLinkUnlinkContainerView.hidden = YES;
    self.proposeFacebookLinkUnlinkButton.enabled = YES;
    if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self.proposeFacebookLinkUnlinkButton setTitle:kLinkedToFacebookTitle forState:UIControlStateNormal];
    } else {
        [self.proposeFacebookLinkUnlinkButton setTitle:kNotLinkedToFacebookTitle forState:UIControlStateNormal];
    }
    
    // Configure facebook container view controller.
    self.facebookContainerView.hidden = YES;
    
    // Configure link/unlink buttons
    [self.linkUnlinkFacebookButton setBackgroundImage:[UIImage imageNamed:@"profile_facebook_link_button_normal"]
                                             forState:UIControlStateNormal];
    [self.linkUnlinkFacebookButton setBackgroundImage:[UIImage imageNamed:@"profile_facebook_link_button_pressed"]
                                             forState:UIControlStateHighlighted];

    [self.cancelFacebookLinkProposeButton setBackgroundImage:[UIImage imageNamed:@"profile_facebook_link_button_normal"]
                                                    forState:UIControlStateNormal];
    [self.cancelFacebookLinkProposeButton setBackgroundImage:[UIImage imageNamed:@"profile_facebook_link_button_pressed"]
                                                    forState:UIControlStateHighlighted];
}

- (void)configureNavigationBar {
    [self.navigationItem setHidesBackButton:YES];
    
    UIImage *barImageNormal = [UIImage imageNamed:@"barButtonNormal"];
    UIImage *barImagePressed = [UIImage imageNamed:@"barButtonPressed"];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect editButtonFrame = CGRectMake(0, 0, barImageNormal.size.width, barImageNormal.size.height);
    [self.editButton setBackgroundImage:barImageNormal forState:UIControlStateNormal];
    [self.editButton setBackgroundImage:barImagePressed forState:UIControlStateHighlighted];
    [self.editButton setTitle:@"Изменить" forState:UIControlStateNormal];
    [self.editButton setTitle:@"Изменить" forState:UIControlStateHighlighted];
    self.editButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    self.editButton.frame = editButtonFrame;
    [self.editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editButton];
    [editBarButtonItem setTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = editBarButtonItem;
}

- (void)configureUI {
    self.title = @"Профиль";
    [self configureNavigationBar];
    [self configureFacebookUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUI];

    self.selectBloodGroupViewController = [[SelectBloodGroupViewController alloc] init];
    self.selectBloodGroupViewController.delegate = self;
    self.sexSelectViewController = [[ProfileSexSelectViewController alloc] init];
    self.sexSelectViewController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    PFUser *user = [PFUser currentUser];
    NSString *buttonTite;
    switch ([[user objectForKey:@"BloodGroup"] intValue])
    {
        case 0:
            buttonTite = @"O(I)";
            break;
        case 1:
            buttonTite = @"A(II)";
            break;
        case 2:
            buttonTite = @"B(III)";
            break;
        case 3:
            buttonTite = @"AB(IV)";
            break;
        default:
            buttonTite = @"O(I)";
            break;
    }
    
    if ([[user objectForKey:@"BloodRh"] intValue] == 0)
        buttonTite = [NSString stringWithFormat:@"%@RH+", buttonTite];
    else
        buttonTite = [NSString stringWithFormat:@"%@RH-", buttonTite];
    
    [self.bloodGroupButton setTitle:buttonTite forState:UIControlStateNormal];
    [self.bloodGroupButton setTitle:buttonTite forState:UIControlStateHighlighted];
    
    if ([[user objectForKey:@"Sex"] intValue] == 0)
    {
        [self.sexButton setTitle:@"муж" forState:UIControlStateNormal];
        [self.sexButton setTitle:@"муж" forState:UIControlStateHighlighted];
    }
    else
    {
        [self.sexButton setTitle:@"жен" forState:UIControlStateNormal];
        [self.sexButton setTitle:@"жен" forState:UIControlStateHighlighted];
    }
    
    self.nameTextField.text = [user objectForKey:@"Name"];
    self.nameTextField.textColor = [UIColor colorWithRed:132.0f/255.0f green:113.0f/255.0f blue:104.0f/255.0f alpha:1];
    //Private property setting
    [self.nameTextField setValue:[UIColor colorWithRed:132.0f/255.0f green:113.0f/255.0f blue:104.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    if (self.calendarInfoDelegate != nil) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd.MM.yyyy"];
        
        NSDate *nextBloodDonationDate = [self.calendarInfoDelegate nextBloodDonationDate];
        self.nextBloodDonateDateLabel.text = nextBloodDonationDate != nil ?
                [dateFormat stringFromDate:nextBloodDonationDate] : @"-";
        
        self.bloodDonationCountLabel.text = [NSString stringWithFormat:@"%d",
                [self.calendarInfoDelegate numberOfDoneBloodDonationEvents]];
    }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setLinkUnlinkFacebookButton:nil];
    [self setCancelFacebookLinkProposeButton:nil];
    [super viewDidUnload];
}
@end
