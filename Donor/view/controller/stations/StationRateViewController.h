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

/// @name UI properties
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImage;

@property (nonatomic, weak) IBOutlet UIImageView *ratedStar1;
@property (nonatomic, weak) IBOutlet UIImageView *ratedStar2;
@property (nonatomic, weak) IBOutlet UIImageView *ratedStar3;
@property (nonatomic, weak) IBOutlet UIImageView *ratedStar4;
@property (nonatomic, weak) IBOutlet UIImageView *ratedStar5;

@property (nonatomic, weak) IBOutlet UILabel *stationTitleLable;
@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextView *commentTextField;

@property (nonatomic, strong) PFObject *station;
@property (nonatomic, assign) float fullRate;

@property (nonatomic, weak) IBOutlet UIButton *workOfRegistryRateButton1;
@property (nonatomic, weak) IBOutlet UIButton *workOfRegistryRateButton2;
@property (nonatomic, weak) IBOutlet UIButton *workOfRegistryRateButton3;
@property (nonatomic, weak) IBOutlet UIButton *workOfRegistryRateButton4;
@property (nonatomic, weak) IBOutlet UIButton *workOfRegistryRateButton5;
@property (nonatomic, assign) int workOfRegistryVote;

@property (nonatomic, weak) IBOutlet UIButton *workOfTherapistRateButton1;
@property (nonatomic, weak) IBOutlet UIButton *workOfTherapistRateButton2;
@property (nonatomic, weak) IBOutlet UIButton *workOfTherapistRateButton3;
@property (nonatomic, weak) IBOutlet UIButton *workOfTherapistRateButton4;
@property (nonatomic, weak) IBOutlet UIButton *workOfTherapistRateButton5;
@property (nonatomic, assign) int workOfTherapistVote;

@property (nonatomic, weak) IBOutlet UIButton *workOfLabRateButton1;
@property (nonatomic, weak) IBOutlet UIButton *workOfLabRateButton2;
@property (nonatomic, weak) IBOutlet UIButton *workOfLabRateButton3;
@property (nonatomic, weak) IBOutlet UIButton *workOfLabRateButton4;
@property (nonatomic, weak) IBOutlet UIButton *workOfLabRateButton5;
@property (nonatomic, assign) int workOfLabVote;

@property (nonatomic, weak) IBOutlet UIButton *workOfBuffetRateButton1;
@property (nonatomic, weak) IBOutlet UIButton *workOfBuffetRateButton2;
@property (nonatomic, weak) IBOutlet UIButton *workOfBuffetRateButton3;
@property (nonatomic, weak) IBOutlet UIButton *workOfBuffetRateButton4;
@property (nonatomic, weak) IBOutlet UIButton *workOfBuffetRateButton5;
@property (nonatomic, assign) int workOfBuffetVote;

@property (nonatomic, weak) IBOutlet UIButton *scheduleRateButton1;
@property (nonatomic, weak) IBOutlet UIButton *scheduleRateButton2;
@property (nonatomic, weak) IBOutlet UIButton *scheduleRateButton3;
@property (nonatomic, weak) IBOutlet UIButton *scheduleRateButton4;
@property (nonatomic, weak) IBOutlet UIButton *scheduleRateButton5;
@property (nonatomic, assign) int scheduleVote;

@property (nonatomic, weak) IBOutlet UIButton *bloodDonateOrganizationRateButton1;
@property (nonatomic, weak) IBOutlet UIButton *bloodDonateOrganizationRateButton2;
@property (nonatomic, weak) IBOutlet UIButton *bloodDonateOrganizationRateButton3;
@property (nonatomic, weak) IBOutlet UIButton *bloodDonateOrganizationRateButton4;
@property (nonatomic, weak) IBOutlet UIButton *bloodDonateOrganizationRateButton5;
@property (nonatomic, assign) int bloodDonateOrganizationVote;

@property (nonatomic, weak) IBOutlet UIButton *pointOfDonationSpaceRateButton1;
@property (nonatomic, weak) IBOutlet UIButton *pointOfDonationSpaceRateButton2;
@property (nonatomic, weak) IBOutlet UIButton *pointOfDonationSpaceRateButton3;
@property (nonatomic, weak) IBOutlet UIButton *pointOfDonationSpaceRateButton4;
@property (nonatomic, weak) IBOutlet UIButton *pointOfDonationSpaceRateButton5;
@property (nonatomic, assign) int pointOfDonationSpaceVote;

/// @name Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil station:(PFObject *)object rate:(float)rate;

/// @name UI Action
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

