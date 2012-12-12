//
//  HSContraindicationCell.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 10.12.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSContraindicationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *details;
@property (weak, nonatomic) IBOutlet UIImageView *separationLine;
@property (weak, nonatomic) IBOutlet UILabel *asterixLabel;
@property (weak, nonatomic) IBOutlet UILabel *dashLabel;

+ (CGFloat)calculateHightForTitle:(NSString *)title details:(NSString *)details indentation:(NSUInteger)indentation;

@end
