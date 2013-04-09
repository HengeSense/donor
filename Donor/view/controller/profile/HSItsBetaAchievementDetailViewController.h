//
//  HSItsBetaAchievementDetailViewController.h
//  Donor
//
//  Created by Alexander Trifonov on 4/9/13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSItsBetaAchievementDetailViewController : UIViewController

@property (nonatomic, strong) NSString *objectID;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *badgeView;

@end
