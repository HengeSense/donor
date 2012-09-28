//
//  EventViewController.h
//  BloodDonor
//
//  Created by Andrey Rebrik on 23.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SLabel.h"

@interface EventViewController : UIViewController
{
    UIView *indicatorView;
    NSString *eventId;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIView *bloodDonateView;
    IBOutlet UILabel *eventBloodDonateTypeLabel;
    IBOutlet UIButton *eventBloodDonateDateButton;
    IBOutlet SLabel *eventBloodDonateCommentLabel;
    IBOutlet UILabel *eventBloodDonateLocationLabel;
    
    IBOutlet UIView *testView;
    IBOutlet UIButton *eventTestDateButton;
    IBOutlet UIButton *eventTestReminderDateButton;
    IBOutlet UIButton *eventTestReminderKnowButton;
    IBOutlet SLabel *eventTestCommentLabel;
    IBOutlet UILabel *eventTestLocationLabel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil event:(NSString *)event;

- (IBAction)backButtonClick:(id)sender;
- (void)editButtonClick:(id)sender;

@end
