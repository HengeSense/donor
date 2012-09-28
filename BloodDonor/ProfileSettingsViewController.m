//
//  ProfileSettingsViewController.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileSettingsViewController.h"
#import "Common.h"

@implementation ProfileSettingsViewController

#pragma mark Actions

- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)passwordButtonClick:(id)sender
{
    [self switchStateOfSegmentButton:(UIButton *)sender needSwitch:YES];
    [Common getInstance].isNeedPassword = !passwordButton.selected;
}

- (IBAction)pushAnnotationsButtonClick:(id)sender
{
    [self switchStateOfSegmentButton:(UIButton *)sender needSwitch:YES];
    [Common getInstance].isNeedPushAnnotations = !pushAnnotationsButton.selected;
}

- (IBAction)expressSearchButtonClick:(id)sender
{
    [self switchStateOfSegmentButton:(UIButton *)sender needSwitch:YES];
    [Common getInstance].isNeedExpressSearch = !expressSearchButton.selected;
}

- (IBAction)remindersButtonClick:(id)sender
{
    [self switchStateOfSegmentButton:(UIButton *)sender needSwitch:YES];
    [Common getInstance].isNeedReminders = !remindersButton.selected;
}

- (IBAction)closingEventButtonClick:(id)sender
{
    [self switchStateOfSegmentButton:(UIButton *)sender needSwitch:YES];
    [Common getInstance].isNeedClosingEvent = !closingEventButton.selected;
}

- (IBAction)plateletsButtonClick:(id)sender
{
    [self switchStateOfSegmentButton:(UIButton *)sender needSwitch:YES];
    [Common getInstance].isNeedPlateletsPush = !plateletsButton.selected;
}

- (IBAction)wholeButtonClick:(id)sender
{
    [self switchStateOfSegmentButton:(UIButton *)sender needSwitch:YES];
    [Common getInstance].isNeedWholeBloodPush = !wholeButton.selected;
}

- (IBAction)plasmaButtonClick:(id)sender
{
    [self switchStateOfSegmentButton:(UIButton *)sender needSwitch:YES];
    [Common getInstance].isNeedPlasmaPush = !plasmaButton.selected;
}

- (void) switchStateOfSegmentButton:(UIButton *)button needSwitch:(BOOL)isNeedSwitch
{
    if (isNeedSwitch)
        button.selected = !button.selected;
    
    if (button.selected)
        [button setImage:[UIImage imageNamed:@"segmentButtonOff.png"] forState:UIControlStateHighlighted];
    else if (!button.selected)
        [button setImage:[UIImage imageNamed:@"segmentButtonOn.png"] forState:UIControlStateHighlighted];
    
    //return button.selected;
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Настройки";
    
    scrollView.contentSize = backgroundImage.frame.size;
   
    [self switchStateOfSegmentButton:passwordButton needSwitch:![Common getInstance].isNeedPassword];
    [self switchStateOfSegmentButton:pushAnnotationsButton needSwitch:![Common getInstance].isNeedPushAnnotations];
    [self switchStateOfSegmentButton:expressSearchButton needSwitch:![Common getInstance].isNeedExpressSearch];
    [self switchStateOfSegmentButton:remindersButton needSwitch:![Common getInstance].isNeedReminders];
    [self switchStateOfSegmentButton:closingEventButton needSwitch:![Common getInstance].isNeedClosingEvent];
    [self switchStateOfSegmentButton:plateletsButton needSwitch:![Common getInstance].isNeedPlateletsPush];
    [self switchStateOfSegmentButton:wholeButton needSwitch:![Common getInstance].isNeedWholeBloodPush];
    [self switchStateOfSegmentButton:plasmaButton needSwitch:![Common getInstance].isNeedPlasmaPush];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [super dealloc];
}

@end
