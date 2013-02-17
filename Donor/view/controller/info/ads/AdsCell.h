//
//  AdsCell.h
//  BloodDonor
//
//  Created by Владимир Носков on 27.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdsCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *adsTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *stationLabel;

@end
