//
//  AppDelegate.h
//  BloodDonor
//
//  Created by Andrey Rebrik on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STabBarController.h"

#import "ItsBeta.h"

@interface AppDelegate : UIResponder < UIApplicationDelegate, UITabBarControllerDelegate, ItsBetaApplicationDelegate >

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) STabBarController *sTabBarController;

@end
