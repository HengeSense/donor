//
//  ReviewsCell.h
//  BloodDonor
//
//  Created by Владимир Носков on 12.08.12.
//
//

#import <UIKit/UIKit.h>

@interface ReviewsCell : UITableViewCell
{
    UIImageView *ratedStar1;
    UIImageView *ratedStar2;
    UIImageView *ratedStar3;
    UIImageView *ratedStar4;
    UIImageView *ratedStar5;
    
    UILabel *nameLabel;
    UILabel *dateLabel;
    UILabel *reviewLabel;
}

@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, retain) IBOutlet UIImageView *ratedStar1;
@property (nonatomic, retain) IBOutlet UIImageView *ratedStar2;
@property (nonatomic, retain) IBOutlet UIImageView *ratedStar3;
@property (nonatomic, retain) IBOutlet UIImageView *ratedStar4;
@property (nonatomic, retain) IBOutlet UIImageView *ratedStar5;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *reviewLabel;

@end
