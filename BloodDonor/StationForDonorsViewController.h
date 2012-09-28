//
//  StationForDonorsViewController.h
//  BloodDonor
//
//  Created by Владимир Носков on 07.08.12.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface StationForDonorsViewController : UIViewController
{
    IBOutlet UIScrollView *contentScrollView;
    
    IBOutlet UIImageView *ratedStar1;
    IBOutlet UIImageView *ratedStar2;
    IBOutlet UIImageView *ratedStar3;
    IBOutlet UIImageView *ratedStar4;
    IBOutlet UIImageView *ratedStar5;
    
    IBOutlet UILabel *receiptTimeLabel;
    IBOutlet UILabel *passageLabel;
    IBOutlet UILabel *bloodDonateForLabel;
    IBOutlet UILabel *bloodDonateTypeLabel;
    IBOutlet UILabel *durationLabel;
   
    IBOutlet UILabel *stationTitleLable;
    PFObject *station;
    
    float fullRate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil station:(PFObject *)object rate:(float)rate;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)ratePressed:(id)sender;

@end
