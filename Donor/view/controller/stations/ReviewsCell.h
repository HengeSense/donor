//
//  ReviewsCell.h
//  BloodDonor
//
//  Created by Владимир Носков on 12.08.12.
//
//

#import <UIKit/UIKit.h>

@interface ReviewsCell : UITableViewCell

@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, weak) IBOutlet UIImageView *ratedStar1;
@property (nonatomic, weak) IBOutlet UIImageView *ratedStar2;
@property (nonatomic, weak) IBOutlet UIImageView *ratedStar3;
@property (nonatomic, weak) IBOutlet UIImageView *ratedStar4;
@property (nonatomic, weak) IBOutlet UIImageView *ratedStar5;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *reviewLabel;

@end
