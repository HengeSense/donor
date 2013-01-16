//
//  StationForDonorsViewController.h
//  BloodDonor
//
//  Created by Владимир Носков on 07.08.12.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface StationForDonorsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIScrollView *contentScrollView;
    
    IBOutlet UITableView *contentTable;
    
    IBOutlet UIImageView *ratedStar1;
    IBOutlet UIImageView *ratedStar2;
    IBOutlet UIImageView *ratedStar3;
    IBOutlet UIImageView *ratedStar4;
    IBOutlet UIImageView *ratedStar5;
    
    IBOutlet UILabel *stationTitleLable;
    PFObject *station;
    
    float fullRate;
    
    NSMutableArray *descriptionLabelsHeights;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil station:(PFObject *)object rate:(float)rate;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)ratePressed:(id)sender;

@end
