//
//  FilterViewController.m
//  BloodDonor
//
//  Created by Владимир Носков on 06.08.12.
//
//

#import "FilterViewController.h"
#import "Common.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

#pragma mare Actions

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonPressed:(id)sender
{
    [Common getInstance].isMoscow = moscowButton.selected;
    [Common getInstance].isPeterburg = peterburgButton.selected;
    [Common getInstance].isRegionalRegistration = regionalRegistrationButton.selected;
    [Common getInstance].isWorkAtSaturday = workAtSaturdayButton.selected;
    [Common getInstance].isDonorsForChildren = donorsForChildrenButton.selected;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)filterSelected:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 0 && !button.selected)
    {
        moscowDot.hidden = !moscowDot.hidden;
        peterburgDot.hidden = YES;
        peterburgButton.selected = NO;
        button.selected = !button.selected;
    }
    else if (button.tag == 1 && !button.selected)
    {
        peterburgDot.hidden = !peterburgDot.hidden;
        button.selected = !button.selected;
        moscowDot.hidden = YES;
        moscowButton.selected = NO;
    }
    else if (button.tag == 2)
    {
        regionalRegistrationDot.hidden = !regionalRegistrationDot.hidden;
        button.selected = !button.selected;
    }
    else if (button.tag == 3)
    {
        workAtSaturdayDot.hidden = !workAtSaturdayDot.hidden;
        button.selected = !button.selected;
    }
    else if (button.tag == 4)
    {
        donorsForChildrenDot.hidden = !donorsForChildrenDot.hidden;
        button.selected = !button.selected;
    }
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
    self.title = @"Фильтр";
    
    UIImage *barImageNormal = [UIImage imageNamed:@"barButtonNormal"];
    UIImage *barImagePressed = [UIImage imageNamed:@"barButtonPressed"];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect doneButtonFrame = CGRectMake(0, 0, barImageNormal.size.width, barImageNormal.size.height);
    [doneButton setBackgroundImage:barImageNormal forState:UIControlStateNormal];
    [doneButton setBackgroundImage:barImagePressed forState:UIControlStateHighlighted];
    [doneButton setTitle:@"Готово" forState:UIControlStateNormal];
    [doneButton setTitle:@"Готово" forState:UIControlStateHighlighted];
    doneButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    doneButton.frame = doneButtonFrame;
    [doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *doneBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:doneButton] autorelease];
    [doneBarButtonItem setTitlePositionAdjustment:UIOffsetMake(0, -1) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = doneBarButtonItem;
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([Common getInstance].isMoscow)
    {
        moscowDot.hidden = NO;
        moscowButton.selected = YES;
    }
    if ([Common getInstance].isPeterburg)
    {
        peterburgDot.hidden = NO;
        peterburgButton.selected = YES;
    }
    if ([Common getInstance].isRegionalRegistration)
    {
        regionalRegistrationDot.hidden = NO;
        regionalRegistrationButton.selected = YES;
    }
    if ([Common getInstance].isWorkAtSaturday)
    {
        workAtSaturdayDot.hidden = NO;
        workAtSaturdayButton.selected = YES;
    }
    if ([Common getInstance].isDonorsForChildren)
    {
        donorsForChildrenDot.hidden = NO;
        donorsForChildrenButton.selected = YES;
    }
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
