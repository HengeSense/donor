//
//  FilterViewController.h
//  BloodDonor
//
//  Created by Владимир Носков on 06.08.12.
//
//

#import <UIKit/UIKit.h>

@interface FilterViewController : UIViewController
{
    IBOutlet UIImageView *moscowDot;
    IBOutlet UIImageView *peterburgDot;
    IBOutlet UIImageView *regionalRegistrationDot;
    IBOutlet UIImageView *workAtSaturdayDot;
    IBOutlet UIImageView *donorsForChildrenDot;
    
    IBOutlet UIButton *moscowButton;
    IBOutlet UIButton *peterburgButton;
    IBOutlet UIButton *regionalRegistrationButton;
    IBOutlet UIButton *workAtSaturdayButton;
    IBOutlet UIButton *donorsForChildrenButton;
}

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)filterSelected:(id)sender;

@end
