//
//  HSLoginViewController.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 10.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSLoginViewController.h"

#import "AppDelegate.h"

#import "HSFlurryAnalytics.h"
#import "HSMailChimp.h"

#import "HSUserInfo.h"
#import "HSCalendar.h"
#import "HSCalendarViewController.h"
#import "HSProfileDescriptionViewController.h"
#import "HSAlertViewController.h"

#import "ItsBeta.h"

@interface HSLoginViewController ()

@end

@implementation HSLoginViewController

- (void)processAuthorizationSuccessWithUser:(PFUser *)user completion:(void(^)(void))completion {
    [self showTabBar];
    if (user.isNew) {
        [HSFlurryAnalytics userRegistered];
    }
    [HSFlurryAnalytics userLoggedIn];
    [[HSMailChimp sharedInstance] subscribeOrUpdateUser:user];
    
    HSCalendar *calendarModel = [HSCalendar sharedInstance];
    [calendarModel unlockModelWithUser:user];
    [calendarModel pullEventsFromServer:^(BOOL success, NSError *error) {
        completion();
        if (success == YES) {
            HSProfileDescriptionViewController *controller = [[HSProfileDescriptionViewController alloc] initWithNibName:@"HSProfileDescriptionViewController" bundle:nil];
            controller.calendarInfoDelegate = calendarModel;
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            [HSAlertViewController showWithMessage:@"Ошибка при загрузке событий календаря"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (void)processAuthorizationWithError:(NSError *)error {
    [HSAlertViewController showWithMessage:[HSModelCommon localizedDescriptionForParseError:error]];
}

- (void)specifyPlatformInfoForUser:(PFUser *)user {
    HSUserInfo *userInfo = [[HSUserInfo alloc] initWithUser:user];
    userInfo.devicePlatform = HSDevicePlatformType_iPhone;
    [userInfo applyChanges];
}

#pragma mark - Private
#pragma mark - UI configuration
- (void)showTabBar {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate setTabBarHidden:NO animated:YES];
}
@end
