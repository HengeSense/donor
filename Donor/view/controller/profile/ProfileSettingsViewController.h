//
//  ProfileSettingsViewController.h
//  BloodDonor
//
//  Created by Andrey Rebrik on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileSettingsViewController : UIViewController
{
    IBOutlet UIImageView *backgroundImage;
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIButton *passwordButton;
    IBOutlet UIButton *pushAnnotationsButton;
    IBOutlet UIButton *expressSearchButton;
    IBOutlet UIButton *remindersButton;
    IBOutlet UIButton *closingEventButton;
    IBOutlet UIButton *plateletsButton;
    IBOutlet UIButton *wholeButton;
    IBOutlet UIButton *plasmaButton;
}

- (IBAction)backButtonClick:(id)sender;
- (IBAction)passwordButtonClick:(id)sender;
- (IBAction)pushAnnotationsButtonClick:(id)sender;
- (IBAction)expressSearchButtonClick:(id)sender;
- (IBAction)remindersButtonClick:(id)sender;
- (IBAction)closingEventButtonClick:(id)sender;
- (IBAction)plateletsButtonClick:(id)sender;
- (IBAction)wholeButtonClick:(id)sender;
- (IBAction)plasmaButtonClick:(id)sender;

- (void) switchStateOfSegmentButton:(UIButton *)button needSwitch:(BOOL)isNeedSwitch;

@end
