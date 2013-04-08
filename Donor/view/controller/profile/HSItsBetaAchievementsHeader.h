//
//  HSItsBetaAchievementsHeader.h
//  Donor
//
//  Created by Alexander Trifonov on 4/8/13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSItsBetaAchievementsHeader : UIView

@property (weak, nonatomic) IBOutlet UILabel* titleView;

@property(nonatomic, readwrite, strong) NSString* title;

@end
