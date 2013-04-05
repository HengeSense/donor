//
//  HSItsBetaAchievementsCell.h
//  Donor
//
//  Created by Alexander Trifonov on 4/5/13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItsBetaObjectTemplate;

@interface HSItsBetaAchievementsCell : UITableViewCell

@property(nonatomic, readwrite, strong) ItsBetaObjectTemplate* objectTemplate;
@property(nonatomic, readwrite) BOOL isExists;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLable;

@end
