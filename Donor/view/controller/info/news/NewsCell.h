//
//  NewsCell.h
//  BloodDonor
//
//  Created by Владимир Носков on 26.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *newsTitleLabel;

@end
