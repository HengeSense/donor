//
//  TempContraindicationsCell.h
//  BloodDonor
//
//  Created by Владимир Носков on 05.08.12.
//
//

#import <UIKit/UIKit.h>

@interface TempContraindicationsCell : UITableViewCell
{
    UILabel *illnessLabel;
    UILabel *timeAllotmentLabel;
    UIImageView *verticalDottedLine;
}

@property (nonatomic, retain) IBOutlet UILabel *illnessLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeAllotmentLabel;
@property (nonatomic, retain) IBOutlet UIImageView *verticalDottedLine;

@end
