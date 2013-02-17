//
//  StationReviewsViewController.h
//  BloodDonor
//
//  Created by Владимир Носков on 07.08.12.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface StationReviewsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

/// @name UI properties
@property (nonatomic, weak) IBOutlet UIImageView *ratedStar1;
@property (nonatomic, weak) IBOutlet UIImageView *ratedStar2;
@property (nonatomic, weak) IBOutlet UIImageView *ratedStar3;
@property (nonatomic, weak) IBOutlet UIImageView *ratedStar4;
@property (nonatomic, weak) IBOutlet UIImageView *ratedStar5;
@property (nonatomic, weak) IBOutlet UILabel *stationTitleLable;

/// @name Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil station:(PFObject *)object
                 rate:(float)rate reviews:(NSArray *)arrayList;

/// @name UI Action
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)ratePressed:(id)sender;

@end
