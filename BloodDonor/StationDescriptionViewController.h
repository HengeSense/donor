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
    
    IBOutlet UIView *forDodonorsView;
    IBOutlet UIButton *reviewsButton;
    IBOutlet UILabel *reviewsLabel;
    IBOutlet UILabel *adsLabel;
    IBOutlet UIView *adsView;
    
    IBOutlet UILabel *stationTitleLable;
    IBOutlet UILabel *addressLable;
    IBOutlet UIWebView *phoneWebView;
    IBOutlet UIWebView *descriptionWebView;
    IBOutlet UIWebView *siteLinkWebView;
    
    UIView *indicatorView;
    NSArray *reviewsArrayList;
    PFObject *station;
    float fullRate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil station:(PFObject *)object;
- (void)callbackWithResult:(NSArray *)result error:(NSError *)error;
- (NSString *)stringByStrippingHTML:(NSString *)inputString;

- (IBAction)ratePressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)forDonorsPressed:(id)sender;
- (IBAction)adsPressed:(id)sender;
- (IBAction)reviewsPressed:(id)sender;
- (IBAction)showOnMapPressed:(id)sender;

@end
