//
//  SelectSexViewControllerViewController.m
//  BloodDonor
//
//  Created by Владимир Носков on 16.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectSexViewController.h"
#import "Common.h"

@implementation SelectSexViewController

@synthesize delegate;

#pragma mark Actions
- (IBAction)cancelClick:(id)sender
{
    [self.view removeFromSuperview];
}
- (IBAction)doneClick:(id)sender;
{
    [delegate sexChanged:@""];
    [self.view removeFromSuperview];
}

#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
