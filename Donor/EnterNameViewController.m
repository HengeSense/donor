//
//  EnterNameViewController.m
//  BloodDonor
//
//  Created by Владимир Носков on 16.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EnterNameViewController.h"
#import "Common.h"

@interface EnterNameViewController ()

@end

@implementation EnterNameViewController

@synthesize delegate;

#pragma mark Actions
- (IBAction)cancelClick:(id)sender
{
    [self.view removeFromSuperview];
}
- (IBAction)doneClick:(id)sender;
{
    [delegate nameEntered:@""];
    [self.view removeFromSuperview];
}


#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
