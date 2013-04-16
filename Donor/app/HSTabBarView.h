//
//  HSTabBarView.h
//  Donor
//
//  Created by Sergey Seroshtan on 16.04.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STabBarController;

@interface HSTabBarView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *tabBarBackground;
@property (nonatomic, strong) IBOutlet UIButton *calendarButton;
@property (nonatomic, strong) IBOutlet UIButton *stationsButton;
@property (nonatomic, strong) IBOutlet UIButton *infoButton;
@property (nonatomic, strong) IBOutlet UIButton *profileButton;

- (void)selectTab:(NSUInteger)tabIndex;

@end
