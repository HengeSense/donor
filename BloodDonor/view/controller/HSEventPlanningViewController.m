//
//  HSEventPlanningViewController.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 25.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSEventPlanningViewController.h"

@interface HSEventPlanningViewController ()

@end

@implementation HSEventPlanningViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDataAndPlaceView:nil];
    [self setBloodDonationTypeView:nil];
    [self setCommentsTextView:nil];
    [self setBloodEventTypeLabel:nil];
    [self setBloodDonationTypeLabel:nil];
    [self setBoodEventDateLabel:nil];
    [self setBloodDonationCenterAddressLabel:nil];
    [super viewDidUnload];
}
- (IBAction)removeBloodEvent:(id)sender {
}

- (IBAction)changeBloodDonationEventType:(id)sender {
}

- (IBAction)selectBloodDonationType:(id)sender {
}
- (IBAction)selectBloodDonationCenterAddress:(id)sender {
}

- (IBAction)selectBloodDonationEventDate:(id)sender {
}
@end
