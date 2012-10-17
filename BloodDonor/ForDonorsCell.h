//
//  ForDonorsCell.h
//  BloodDonor
//
//  Created by Vladimir Noskov on 12.10.12.
//
//

#import <UIKit/UIKit.h>

@interface ForDonorsCell : UITableViewCell
{
    UILabel *titleLabel;
    UILabel *descriptionLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;


@end
