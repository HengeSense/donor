//
//  AdsCell.h
//  BloodDonor
//
//  Created by Владимир Носков on 27.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdsCell : UITableViewCell
{
    UILabel *dateLabel;
    UILabel *newsTitleLabel;
    UILabel *stationLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *adsTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *stationLabel;

@end
