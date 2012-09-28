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
{
    IBOutlet UIImageView *ratedStar1;
    IBOutlet UIImageView *ratedStar2;
    IBOutlet UIImageView *ratedStar3;
    IBOutlet UIImageView *ratedStar4;
    IBOutlet UIImageView *ratedStar5;
    
    IBOutlet UILabel *stationTitleLable;
    
    NSArray *reviewsArray;
    NSMutableArray *contentArray;
    
    PFObject *station;
    
    NSInteger selectedRow;
    
    CGFloat selectedRowHeight;
    
    float fullRate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil station:(PFObject *)object rate:(float)rate reviews:(NSArray *)arrayList;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)ratePressed:(id)sender;

@end
