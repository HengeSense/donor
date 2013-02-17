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

/// @name UI Properties
@property (nonatomic, strong) IBOutlet UIScrollView *contentScrollView;

@property (nonatomic, strong) UIImageView *ratedStar1;
@property (nonatomic, strong) IBOutlet UIImageView *ratedStar2;
@property (nonatomic, strong) IBOutlet UIImageView *ratedStar3;
@property (nonatomic, strong) IBOutlet UIImageView *ratedStar4;
@property (nonatomic, strong) IBOutlet UIImageView *ratedStar5;

@property (nonatomic, strong) IBOutlet UIView *infoView;
@property (nonatomic, strong) IBOutlet UIView *buttonsView;

@property (nonatomic, strong) IBOutlet UIView *forDodonorsView;
@property (nonatomic, strong) IBOutlet UIButton *reviewsButton;
@property (nonatomic, strong) IBOutlet UILabel *reviewsLabel;
@property (nonatomic, strong) IBOutlet UILabel *adsLabel;
@property (nonatomic, strong) IBOutlet UIView *adsView;

@property (nonatomic, strong) IBOutlet UILabel *stationTitleLable;
@property (nonatomic, strong) IBOutlet UILabel *addressLable;
@property (nonatomic, strong) IBOutlet UIWebView *phoneWebView;
@property (nonatomic, strong) IBOutlet UIWebView *descriptionWebView;
@property (nonatomic, strong) IBOutlet UIWebView *siteLinkWebView;

/// @name Functional properties
@property (nonatomic, strong) NSArray *reviewsArrayList;
@property (nonatomic, strong) PFObject *station;
@property (nonatomic, assign) float fullRate;

/// @name Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil station:(PFObject *)object;

/// @name UI Actions
- (IBAction)ratePressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)forDonorsPressed:(id)sender;
- (IBAction)adsPressed:(id)sender;
- (IBAction)reviewsPressed:(id)sender;
- (IBAction)showOnMapPressed:(id)sender;

@end
