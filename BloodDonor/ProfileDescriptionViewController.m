//
//  ProfileDescriptionViewController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileDescriptionViewController.h"
#import "ProfileSettingsViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "Common.h"

@implementation ProfileDescriptionViewController

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
    //Приватное свойство!
    [nameTextField setValue:[UIColor colorWithRed:132.0f/255.0f green:113.0f/255.0f blue:104.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    sexButton.enabled = NO;
    bloodGroupButton.enabled = NO;
    
    /*UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *settingsImageNormal = [UIImage imageNamed:@"settingsButtonNormal"];
    UIImage *settingsImagePressed = [UIImage imageNamed:@"settingsButtonPressed"];
    CGRect settingsButtonFrame = CGRectMake(0, 0, settingsImageNormal.size.width, settingsImageNormal.size.height);
    [settingsButton setImage:settingsImageNormal forState:UIControlStateNormal];
    [settingsButton setImage:settingsImagePressed forState:UIControlStateHighlighted];
    settingsButton.frame = settingsButtonFrame;
    [settingsButton addTarget:self action:@selector(settingsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *settingsBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:settingsButton] autorelease];
    self.navigationItem.leftBarButtonItem = settingsBarButtonItem;*/
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
    }
    else
    {
        hiddenView.hidden = YES;
        [editButton setTitle:@"Готово" forState:UIControlStateNormal];
        [editButton setTitle:@"Готово" forState:UIControlStateHighlighted];
        nameTextField.enabled = YES;
        sexButton.enabled = YES;
        nameTextField.textColor = [UIColor colorWithRed:223.0f/255.0f green:141.0f/255.0f blue:75.0f/255.0f alpha:1];
        //Приватное свойство!
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
    [self showModal:sexSelectViewController.view];
}

- (IBAction)bloodGroupButtonClick:(id)sender
{
    [nameTextField resignFirstResponder];
    [self showModal:selectBoodGroupViewController.view];
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

- (IBAction)exitButtonClick:(id)sender
{
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Профиль";
    
    [self.navigationItem setHidesBackButton:YES];
    
    /*UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *settingsImageNormal = [UIImage imageNamed:@"settingsButtonNormal"];
    UIImage *settingsImagePressed = [UIImage imageNamed:@"settingsButtonPressed"];
    CGRect settingsButtonFrame = CGRectMake(0, 0, settingsImageNormal.size.width, settingsImageNormal.size.height);
    [settingsButton setImage:settingsImageNormal forState:UIControlStateNormal];
    [settingsButton setImage:settingsImagePressed forState:UIControlStateHighlighted];
    settingsButton.frame = settingsButtonFrame;
    [settingsButton addTarget:self action:@selector(settingsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *settingsBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:settingsButton] autorelease];
    self.navigationItem.leftBarButtonItem = settingsBarButtonItem;*/
    
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
    
    selectBoodGroupViewController = [[SelectBloodGroupViewController alloc] init];
    selectBoodGroupViewController.delegate = self;
    sexSelectViewController = [[ProfileSexSelectViewController alloc] init];
    sexSelectViewController.delegate = self;
    
    bloodDonationCountLabel.text = [NSString stringWithFormat:@"%d", [Common getInstance].wholeBloodCount];
    Common *commonStorage = [Common getInstance];
    [commonStorage addObserver: self forKeyPath: @"wholeBloodCount" options: NSKeyValueChangeReplacement context: nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
    //Приватное свойство!
    [nameTextField setValue:[UIColor colorWithRed:132.0f/255.0f green:113.0f/255.0f blue:104.0f/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:@"dd.MM.yyyy"];
    NSDate *date = [NSDate date];
       
    PFRelation *relation = [user relationforKey:@"events"];
    PFQuery *query = [relation query];
    [query whereKey:@"date" notEqualTo:[NSNull null]];
    [query orderByAscending:@"date"];
    [query whereKey:@"date" greaterThanOrEqualTo:date];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
        {
            if (object)
            {
                nextBloodDonateDateLabel.text = [dateFormat stringFromDate:[object valueForKey:@"date"]];
                NSLog(@"%@", object);
            }
            else
            {
                nextBloodDonateDateLabel.text = @"-";
            }

        }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [[Common getInstance] removeObserver: self forKeyPath: @"wholeBloodCount"];
    [super viewDidUnload];
}

- (void)dealloc
{
    [sexSelectViewController release];
    [selectBoodGroupViewController release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString: @"wholeBloodCount"])
    {
        bloodDonationCountLabel.text = [NSString stringWithFormat:@"%d", [Common getInstance].wholeBloodCount];
    }
}

@end
