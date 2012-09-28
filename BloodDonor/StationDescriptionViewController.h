//
//  StationDescriptionViewController.h
//  BloodDonor
//
//  Created by Владимир Носков on 07.08.12.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface StationDescriptionViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIScrollView *contentScrollView;
    
    IBOutlet UIImageView *ratedStar1;
    IBOutlet UIImageView *ratedStar2;
    IBOutlet UIImageView *ratedStar3;
    IBOutlet UIImageView *ratedStar4;
    IBOutlet UIImageView *ratedStar5;
    
    IBOutlet UIView *infoView;
    IBOutlet UIView *buttonsView;
    
    IBOutlet UIButton *reviewsButton;
    IBOutlet UILabel *adsLabel;
    
    IBOutlet UILabel *stationTitleLable;
    IBOutlet UILabel *addressLable;
    IBOutlet UIWebView *phoneWebView;
   // IBOutlet UILabel *phoneNumberLabel;
    //IBOutlet UILabel *descriptionLabel;
    IBOutlet UIWebView *descriptionWebView;
    IBOutlet UIWebView *siteLinkWebView;
    
    UIView *indicatorView;
    NSArray *reviewsArrayList;
    PFObject *station;
    float fullRate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil station:(PFObject *)object;
- (void)callbackWithResult:(NSArray *)result error:(NSError *)error;

- (IBAction)ratePressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)forDonorsPressed:(id)sender;
- (IBAction)adsPressed:(id)sender;
- (IBAction)reviewsPressed:(id)sender;
- (IBAction)showOnMapPressed:(id)sender;

@end
