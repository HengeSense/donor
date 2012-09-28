//
//  STabBarController.h
//  BloodDonor
//
//  Created by Andrey Rebrik on 13.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STabBarController : NSObject <UITabBarControllerDelegate, UITabBarDelegate>
{
    UIImageView *tabBarBackground;
    UIButton *calendarButton;
    UIButton *stationsButton;
    UIButton *infoButton;
    UIButton *profileButton;
}

@property (nonatomic, assign) UITabBarController *tabBarController;

- (void)addSubview;
- (void)removeSubviews;
- (IBAction)tabButtonClick:(id)sender;
- (void)selectTab;

@end
