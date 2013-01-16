//
//  StationRateViewController.h
//  BloodDonor
//
//  Created by Владимир Носков on 08.08.12.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface StationRateViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *backgroundImage;
    
    IBOutlet UIImageView *ratedStar1;
    IBOutlet UIImageView *ratedStar2;
    IBOutlet UIImageView *ratedStar3;
    IBOutlet UIImageView *ratedStar4;
    IBOutlet UIImageView *ratedStar5;
    
    IBOutlet UILabel *stationTitleLable;
    IBOutlet UITextField *nameField;
    IBOutlet UITextView *commentTextField;
    
    PFObject *station;
    float fullRate;
    
    IBOutlet UIButton *workOfRegistryRateButton1;
    IBOutlet UIButton *workOfRegistryRateButton2;
    IBOutlet UIButton *workOfRegistryRateButton3;
    IBOutlet UIButton *workOfRegistryRateButton4;
    IBOutlet UIButton *workOfRegistryRateButton5;
    int workOfRegistryVote;
    
    IBOutlet UIButton *workOfTherapistRateButton1;
    IBOutlet UIButton *workOfTherapistRateButton2;
    IBOutlet UIButton *workOfTherapistRateButton3;
    IBOutlet UIButton *workOfTherapistRateButton4;
    IBOutlet UIButton *workOfTherapistRateButton5;
    int workOfTherapistVote;
    
    IBOutlet UIButton *workOfLabRateButton1;
    IBOutlet UIButton *workOfLabRateButton2;
    IBOutlet UIButton *workOfLabRateButton3;
    IBOutlet UIButton *workOfLabRateButton4;
    IBOutlet UIButton *workOfLabRateButton5;
    int workOfLabVote;
    
    IBOutlet UIButton *workOfBuffetRateButton1;
    IBOutlet UIButton *workOfBuffetRateButton2;
    IBOutlet UIButton *workOfBuffetRateButton3;
    IBOutlet UIButton *workOfBuffetRateButton4;
    IBOutlet UIButton *workOfBuffetRateButton5;
    int workOfBuffetVote;
    
    IBOutlet UIButton *scheduleRateButton1;
    IBOutlet UIButton *scheduleRateButton2;
    IBOutlet UIButton *scheduleRateButton3;
    IBOutlet UIButton *scheduleRateButton4;
    IBOutlet UIButton *scheduleRateButton5;
    int scheduleVote;
    
    IBOutlet UIButton *bloodDonateOrganizationRateButton1;
    IBOutlet UIButton *bloodDonateOrganizationRateButton2;
    IBOutlet UIButton *bloodDonateOrganizationRateButton3;
    IBOutlet UIButton *bloodDonateOrganizationRateButton4;
    IBOutlet UIButton *bloodDonateOrganizationRateButton5;
    int bloodDonateOrganizationVote;
    
    IBOutlet UIButton *pointOfDonationSpaceRateButton1;
    IBOutlet UIButton *pointOfDonationSpaceRateButton2;
    IBOutlet UIButton *pointOfDonationSpaceRateButton3;
    IBOutlet UIButton *pointOfDonationSpaceRateButton4;
    IBOutlet UIButton *pointOfDonationSpaceRateButton5;
    int pointOfDonationSpaceVote;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil station:(PFObject *)object rate:(float)rate;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;

- (IBAction)workOfRegistryRatePressed:(id)sender;
- (IBAction)workOfTherapistRatePressed:(id)sender;
- (IBAction)workOfLabRatePressed:(id)sender;
- (IBAction)workOfBuffetRatePressed:(id)sender;
- (IBAction)scheduleRatePressed:(id)sender;
- (IBAction)bloodDonateOrganizationRatePressed:(id)sender;
- (IBAction)pointOfDonationSpaceRatePressed:(id)sender;

@end

