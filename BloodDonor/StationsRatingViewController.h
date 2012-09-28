//
//  stationsRatingViewController.h
//  BloodDonor
//
//  Created by Владимир Носков on 07.08.12.
//
//

#import <UIKit/UIKit.h>

@interface StationsRatingViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIImageView *ratedStar1;
    IBOutlet UIImageView *ratedStar2;
    IBOutlet UIImageView *ratedStar3;
    IBOutlet UIImageView *ratedStar4;
    IBOutlet UIImageView *ratedStar5;
    
    IBOutlet UILabel *stationTitleLable;
    IBOutlet UILabel *nameLabel;
    IBOutlet UITextField *commentTextField;
    
}

- (IBAction)backButtonPressed:(id)sender;

- (IBAction)workOfRegistryRatePressed:(id)sender;
- (IBAction)workOFTherapistRatePressed:(id)sender;
- (IBAction)workOFLabRatePressed:(id)sender;
- (IBAction)workOFBuffetRatePressed:(id)sender;
- (IBAction)scheduleRatePressed:(id)sender;
- (IBAction)bloodDonateOrganizationRatePressed:(id)sender;
- (IBAction)pointOfDonationSpaceRatePressed:(id)sender;

@end
