//
//  StationAdsViewController.m
//  BloodDonor
//
//  Created by Владимир Носков on 07.08.12.
//
//

#import "StationAdsViewController.h"

@interface StationAdsViewController ()

@end

@implementation StationAdsViewController

#pragma mare Actions

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        sTabBarController = [[STabBarController alloc] init];
        sTabBarController.viewController = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sTabBarController = [[STabBarController alloc] init];
    sTabBarController.viewController = self;
    [sTabBarController addSubview];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [sTabBarController addSubview];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [sTabBarController removeSubviews];
    
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [sTabBarController release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
