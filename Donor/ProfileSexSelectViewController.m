//
//  ProfileSexSelectViewController.m
//  BloodDonor
//
//  Created by Владимир Носков on 18.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileSexSelectViewController.h"
#import "Common.h"
#import <Parse/Parse.h>

@implementation ProfileSexSelectViewController

@synthesize delegate;

#pragma mark Actions

- (IBAction)cancelClick:(id)sender
{
    [delegate sexChanged:sex];
    [self.view removeFromSuperview];
}

- (IBAction)doneClick:(id)sender
{
    [delegate sexChanged:sex];
    
    if ([sex isEqualToString:@"Мужской"])
        [Common getInstance].sex = [NSNumber numberWithInt:0];
    else
        [Common getInstance].sex = [NSNumber numberWithInt:1];
    
    [self.view removeFromSuperview];
}

- (IBAction)sexSelected:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (!button.selected)
        [self setSelectedSexButton:button];
}

- (void)setSelectedSexButton:(UIButton *)button
{
    if (button.tag == 1)
    {
        maleButton.selected = YES;
        femaleButton.selected = NO;
        [maleButton setImage:[UIImage imageNamed:@"radioButtonSelected.png"] forState:UIControlStateHighlighted];
        [femaleButton setImage:[UIImage imageNamed:@"radioButtonNotSelected.png"] forState:UIControlStateHighlighted];
        maleLabel.textColor = [UIColor colorWithRed:223.0f/255.0f green:141.0f/255.0f blue:75.0f/255.0f alpha:1];
        femaleLabel.textColor = [UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1];
        sex = maleLabel.text;
    }
    else if (button.tag == 2)
    {
        maleButton.selected = NO;
        femaleButton.selected = YES;
        [maleButton setImage:[UIImage imageNamed:@"radioButtonNotSelected.png"] forState:UIControlStateHighlighted];
        [femaleButton setImage:[UIImage imageNamed:@"radioButtonSelected.png"] forState:UIControlStateHighlighted];
        maleLabel.textColor = [UIColor colorWithRed:203.0f/255.0f green:178.0f/255.0f blue:163.0f/255.0f alpha:1]; 
        femaleLabel.textColor = [UIColor colorWithRed:223.0f/255.0f green:141.0f/255.0f blue:75.0f/255.0f alpha:1];
        sex = femaleLabel.text;
    }
}

#pragma mark Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    sex = maleLabel.text;
    
    if ([PFUser currentUser])
    {
        PFUser *user = [PFUser currentUser];
        if ([[user objectForKey:@"Sex"] intValue] == 0)
            [self setSelectedSexButton:maleButton];
        else
            [self setSelectedSexButton:femaleButton];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
