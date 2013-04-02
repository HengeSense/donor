//
//  HSProfileDescriptionViewController.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 30.03.13.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSProfileDescriptionViewController.h"

#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "HSFlurryAnalytics.h"
#import "HSMailChimp.h"

#import "AppDelegate.h"
#import "Common.h"
#import "HSAlertViewController.h"
#import "HSModelCommon.h"
#import "NSString+HSUtils.h"
#import "HSCalendar.h"

#import "HSSexType.h"
#import "HSBloodType.h"
#import "HSUserInfo.h"

#import "ItsBeta.h"

static const CGFloat kActionSheetAnimationDuration = 0.2;

static NSString * const kNotLinkedToFacebookTitle = @"не привязан";
static NSString * const kLinkedToFacebookTitle = @"привязан";

@interface HSProfileDescriptionViewController ()

@property (nonatomic, weak) UIView *currentActionSheet;
@property (nonatomic, retain) HSBloodTypePicker *bloodTypePicker;
@property (nonatomic, retain) HSSexPicker *sexPicker;
@property (nonatomic, strong) HSUserInfo *editUserInfo;

@end

@implementation HSProfileDescriptionViewController

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bloodTypePicker = [[HSBloodTypePicker alloc] init];
    self.sexPicker = [[HSSexPicker alloc] init];

    [self configureUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUIComponents];
}

#pragma mark Actions
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
        
        if (![self.editUserInfo.name isNotEmpty]) {
            [HSAlertViewController showWithMessage:@"Имя пользователя не задано."
                resultBlock:^(BOOL isOkButtonPressed) {
                   [self.nameTextField becomeFirstResponder];
            }];
            return;
        }
        [self cancelEditPressed];

        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [self.editUserInfo applyChanges];
        // TODO: Possible saveEventualy is more applicable method. 
        [self.editUserInfo.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [progressHud hide:YES];
            if (succeeded) {
                [HSFlurryAnalytics userUpdatedProfile];
                [[HSMailChimp sharedInstance] subscribeOrUpdateUser:self.editUserInfo.user];
            } else {
                [HSAlertViewController showWithTitle:@"Ошибка"
                                             message:[HSModelCommon localizedDescriptionForParseError:error]];
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

        self.editUserInfo = [[HSUserInfo alloc] initWithUser:[PFUser currentUser]];
        
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
    [self.sexPicker showWithSex:self.editUserInfo.sex completion:^(BOOL isDone) {
        if (isDone) {
            self.editUserInfo.sex = self.sexPicker.sex;
            [self updateSexButtonWithSex:self.editUserInfo.sex];
        }
    }];
}

- (IBAction)bloodGroupButtonClick:(id)sender {
    [self.nameTextField resignFirstResponder];
    [self.bloodTypePicker showWithBloodGroup:self.editUserInfo.bloodGroup bloodRh:self.editUserInfo.bloodRh
            completion:^(BOOL isDone)
    {
        if (isDone) {
            self.editUserInfo.bloodGroup = self.bloodTypePicker.bloodGroup;
            self.editUserInfo.bloodRh = self.bloodTypePicker.bloodRh;
            [self updateBloodTypeButtonWithBloodGroup:self.editUserInfo.bloodGroup bloodRh:self.editUserInfo.bloodRh];
        }
    }];
}

- (IBAction)logoutButtonClick:(id)sender {
    [HSFlurryAnalytics userLoggedOut];
    [[HSCalendar sharedInstance] lockModel];
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)unlinkFacebook {
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser] block:^(BOOL succeeded, NSError *error) {
        [progressHud hide:YES];
        if (succeeded) {
            [self.proposeFacebookLinkUnlinkButton setTitle:kNotLinkedToFacebookTitle forState:UIControlStateNormal];
        } else {
            [HSAlertViewController showWithTitle:@"Ошибка"
                                         message:[HSModelCommon localizedDescriptionForParseError:error]];
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
            [HSAlertViewController showWithTitle:@"Ошибка"
                                         message:[HSModelCommon localizedDescriptionForParseError:error]];
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

- (IBAction)showAchievements:(id)sender {
    // TODO SHOW ACHIEVEMENTS
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.nameTextField) {
        self.editUserInfo.name = self.nameTextField.text;
    }
}

#pragma mark - Private
#pragma mark - UI configuration
- (void)configureUI {
    self.title = @"Профиль";
    
    CGFloat scrollViewWidth = 0.0f;
    CGFloat scrollViewHeight = 0.0f;
    for(UIView* view in [self.scrollView subviews]) {
        CGFloat maxX = CGRectGetMaxX([view frame]);
        CGFloat maxY = CGRectGetMaxY([view frame]);
        scrollViewWidth = MAX(scrollViewWidth, maxX);
        scrollViewHeight = MAX(scrollViewHeight, maxY);
    }
    [self.scrollView setContentSize:CGSizeMake(scrollViewWidth, scrollViewHeight)];
    
    [self configureNavigationBar];
    [self configureFacebookUI];
    [self configureNameTextField];
}

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
    // self.facebookContainerView.hidden = YES;
    
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

- (void)configureNameTextField {
    self.nameTextField.textColor = [UIColor colorWithRed:132.0f/255.0f green:113.0f/255.0f blue:104.0f/255.0f alpha:1];
    //Private property setting
    [self.nameTextField setValue:[UIColor colorWithRed:132.0f/255.0f green:113.0f/255.0f blue:104.0f/255.0f alpha:1]
            forKeyPath:@"_placeholderLabel.textColor"];
}

#pragma mark - UI updating
- (void)updateUIComponents {
    HSUserInfo *userInfo = [[HSUserInfo alloc] initWithUser:[PFUser currentUser]];
    
    self.nameTextField.text = userInfo.name;
    [self updateBloodTypeButtonWithBloodGroup:userInfo.bloodGroup bloodRh:userInfo.bloodRh];
    [self updateSexButtonWithSex:userInfo.sex];
    [self updateBloodDonationInfo];
}

#pragma mark - UI updating
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

- (void)updateBloodDonationInfo {
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

- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
