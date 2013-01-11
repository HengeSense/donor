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

static NSString * const kLinkFacebookTitle = @"Привязать Facebook";
static NSString * const kUnlinkFacebookTitle = @"Отвязать Facebook";

@implementation ProfileDescriptionViewController

@synthesize calendarInfoDelegate;
@synthesize selectBloodGroupViewController;
@synthesize sexSelectViewController;
@synthesize linkUnlinkToFacebookButton;

#pragma mark Actions

- (IBAction)settingsButtonClick:(id)sender
{
    ProfileSettingsViewController *controller = [[[ProfileSettingsViewController alloc] initWithNibName:@"ProfileSettingsViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)cancelEditPressed
{
    hiddenView.hidden = NO;
    [editButton setTitle:@"Изменить" forState:UIControlStateNormal];
    [editButton setTitle:@"Изменить" forState:UIControlStateHighlighted];
    nameTextField.enabled = NO;
    nameTextField.textColor = [UIColor colorWithRed:132.0f/255.0f green:113.0f/255.0f blue:104.0f/255.0f alpha:1];
    //Private property setting
    [nameTextField setValue:[UIColor colorWithRed:132.0f/255.0f green:113.0f/255.0f blue:104.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    sexButton.enabled = NO;
    bloodGroupButton.enabled = NO;
    self.navigationItem.leftBarButtonItem = nil;
}

- (IBAction)editButtonClick:(id)sender
{
    if (hiddenView.hidden)
    {
        [self cancelEditPressed];
        
        [Common getInstance].name = nameTextField.text;
        
        PFUser *user = [PFUser currentUser];
        
        [user setObject:[Common getInstance].sex forKey:@"Sex"];
        [user setObject:[Common getInstance].bloodGroup forKey:@"BloodGroup"];
        [user setObject:[Common getInstance].bloodRH forKey:@"BloodRh"];
        [user setObject:nameTextField.text forKey:@"Name"];
        [user saveInBackground];
        [HSFlurryAnalytics userUpdatedProfile];
    }
    else
    {
        hiddenView.hidden = YES;
        [editButton setTitle:@"Готово" forState:UIControlStateNormal];
        [editButton setTitle:@"Готово" forState:UIControlStateHighlighted];
        nameTextField.enabled = YES;
        sexButton.enabled = YES;
        nameTextField.textColor = [UIColor colorWithRed:223.0f/255.0f green:141.0f/255.0f blue:75.0f/255.0f alpha:1];
        //Private property setting
        [nameTextField setValue:[UIColor colorWithRed:223.0f/255.0f green:141.0f/255.0f blue:75.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        bloodGroupButton.enabled = YES;
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
        
        UIBarButtonItem *cancelBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:cancelButton] autorelease];
        [cancelBarButtonItem setTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    }
}

- (IBAction)sexButtonClick:(id)sender
{
    [nameTextField resignFirstResponder];
    [self showModal:self.sexSelectViewController.view];
}

- (IBAction)bloodGroupButtonClick:(id)sender
{
    [nameTextField resignFirstResponder];
    [self showModal:self.selectBloodGroupViewController.view];
}

- (void) showModal:(UIView*) modalView 
{
    UIWindow* mainWindow = (((AppDelegate*) [UIApplication sharedApplication].delegate).window);
    CGPoint middleCenter = modalView.center;
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
    modalView.center = offScreenCenter;
    [mainWindow addSubview:modalView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    modalView.center = middleCenter;
    [UIView commitAnimations];
}

- (IBAction)logoutButtonClick:(id)sender
{
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

- (IBAction)linkUnlinkToFacebook:(id)sender {
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser] block:^(BOOL succeeded, NSError *error) {
            [progressHud hide:YES];
            if (succeeded) {
                self.linkUnlinkToFacebookButton.titleLabel.text = kLinkFacebookTitle;
            } else {
                [HSAlertViewController showWithTitle:@"Ошибка" message:localizedDescriptionForParseError(error)];
                NSLog(@"Facebook unlink failed due to error: %@", error);
            }
        }];
    } else {
        NSArray *permissions = @[@"user_about_me", @"email"];
        [PFFacebookUtils linkUser:[PFUser currentUser] permissions:permissions block:^(BOOL succeeded, NSError *error) {
            [progressHud hide:YES];
            if (succeeded) {
                self.linkUnlinkToFacebookButton.titleLabel.text = kUnlinkFacebookTitle;
            } else {
                [HSAlertViewController showWithTitle:@"Ошибка" message:localizedDescriptionForParseError(error)];
                NSLog(@"Facebook link failed due to error: %@", error);
            }
        }];
    }
}

#pragma mark SelectBloodGroupDelegate

- (void) bloodGroupChanged:(NSString *)bloodGroup
{
    if (bloodGroup) 
    {
        [bloodGroupButton setTitle:bloodGroup forState:UIControlStateNormal];
        [bloodGroupButton setTitle:bloodGroup forState:UIControlStateHighlighted];
    }
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

- (void)configureUI {
    self.title = @"Профиль";
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIImage *barImageNormal = [UIImage imageNamed:@"barButtonNormal"];
    UIImage *barImagePressed = [UIImage imageNamed:@"barButtonPressed"];
    
    editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect editButtonFrame = CGRectMake(0, 0, barImageNormal.size.width, barImageNormal.size.height);
    [editButton setBackgroundImage:barImageNormal forState:UIControlStateNormal];
    [editButton setBackgroundImage:barImagePressed forState:UIControlStateHighlighted];
    [editButton setTitle:@"Изменить" forState:UIControlStateNormal];
    [editButton setTitle:@"Изменить" forState:UIControlStateHighlighted];
    editButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    editButton.frame = editButtonFrame;
    [editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *editBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:editButton] autorelease];
    [editBarButtonItem setTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = editBarButtonItem;
    
    if ([Common getInstance].authenticatedWithFacebook) {
        self.linkUnlinkToFacebookButton.hidden = YES;
    } else {
        self.linkUnlinkToFacebookButton.hidden = NO;
        if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            self.linkUnlinkToFacebookButton.titleLabel.text = @"Отвязать Facebook";
        } else {
            self.linkUnlinkToFacebookButton.titleLabel.text = @"Привязать Facebook";
        }
    }
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
    
    [bloodGroupButton setTitle:buttonTite forState:UIControlStateNormal];
    [bloodGroupButton setTitle:buttonTite forState:UIControlStateHighlighted];
    
    if ([[user objectForKey:@"Sex"] intValue] == 0)
    {
        [sexButton setTitle:@"муж" forState:UIControlStateNormal];
        [sexButton setTitle:@"муж" forState:UIControlStateHighlighted];
    }
    else
    {
        [sexButton setTitle:@"жен" forState:UIControlStateNormal];
        [sexButton setTitle:@"жен" forState:UIControlStateHighlighted];
    }
    
    nameTextField.text = [user objectForKey:@"Name"];
    nameTextField.textColor = [UIColor colorWithRed:132.0f/255.0f green:113.0f/255.0f blue:104.0f/255.0f alpha:1];
    //Private property setting
    [nameTextField setValue:[UIColor colorWithRed:132.0f/255.0f green:113.0f/255.0f blue:104.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    if (self.calendarInfoDelegate != nil) {
        NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormat setDateFormat:@"dd.MM.yyyy"];
        
        NSDate *nextBloodDonationDate = [self.calendarInfoDelegate nextBloodDonationDate];
        nextBloodDonateDateLabel.text = nextBloodDonationDate != nil ?
                [dateFormat stringFromDate:nextBloodDonationDate] : @"-";
        
        bloodDonationCountLabel.text = [NSString stringWithFormat:@"%d",
                [self.calendarInfoDelegate numberOfDoneBloodDonationEvents]];
    }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self setSexSelectViewController: nil];
    [self setSelectBloodGroupViewController: nil];
    [self setLinkUnlinkToFacebookButton:nil];
}

- (void)dealloc {
    [self setSexSelectViewController: nil];
    [self setSelectBloodGroupViewController: nil];
    [self setLinkUnlinkToFacebookButton:nil];
    [super dealloc];
}

@end
