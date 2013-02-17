//
//  StationsCell.h
//  BloodDonor
//
//  Created by Владимир Носков on 06.08.12.
//
//

#import <UIKit/UIKit.h>

@interface StationsCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *addressLabel;
@property (nonatomic, retain) IBOutlet UIImageView *regionalRegistrationImageView;
@property (nonatomic, retain) IBOutlet UIImageView *workAtSaturdayImageView;
@property (nonatomic, retain) IBOutlet UIImageView *donorsForChildrenImageView;
@property (nonatomic, retain) IBOutlet UIView *shadowSelectionView;
@property (nonatomic, retain) IBOutlet UIImageView *indicatorView;
@property(nonatomic, getter=isHighlighted) BOOL highlighted;
@property(nonatomic) BOOL isEvent;

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
@end
