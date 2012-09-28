//
//  StationsCell.h
//  BloodDonor
//
//  Created by Владимир Носков on 06.08.12.
//
//

#import <UIKit/UIKit.h>

@interface StationsCell : UITableViewCell
{
    UILabel *addressLabel;
    UIImageView *regionalRegistrationImageView;
    UIImageView *workAtSaturdayImageView;
    UIImageView *donorsForChildrenImageView;
    UIView *shadowSelectionView;
}

@property (nonatomic, retain) IBOutlet UILabel *addressLabel;
@property (nonatomic, retain) IBOutlet UIImageView *regionalRegistrationImageView;
@property (nonatomic, retain) IBOutlet UIImageView *workAtSaturdayImageView;
@property (nonatomic, retain) IBOutlet UIImageView *donorsForChildrenImageView;
@property (nonatomic, retain) IBOutlet UIView *shadowSelectionView;

@end
