//
//  HSLoginViewController.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 10.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSLoginViewController.h"
#import "HSFlurryAnalytics.h"

#import "Common.h"
#import "HSCalendar.h"
#import "HSCalendarViewController.h"
#import "ProfileDescriptionViewController.h"
#import "HSAlertViewController.h"

@interface HSLoginViewController ()

@end

@implementation HSLoginViewController

- (void)processAuthorizationSuccessWithUser:(PFUser *)user completion: (void(^)(void))completion {
    if (user.isNew) {
        [HSFlurryAnalytics userRegistered];
    }
    [HSFlurryAnalytics userLoggedIn];
    [Common getInstance].email = [user objectForKey:@"email"];
    [Common getInstance].password = user.password;
    [Common getInstance].name = [user objectForKey:@"Name"];
    [Common getInstance].bloodGroup = [user objectForKey:@"BloodGroup"];
    [Common getInstance].bloodRH = [user objectForKey:@"BloodRh"];
    [Common getInstance].sex = [user objectForKey:@"Sex"];
    
    HSCalendar *calendarModel = [[HSCalendar alloc] init];
    self.calendarViewController.calendarModel = calendarModel;
    [calendarModel pullEventsFromServer:^(BOOL success, NSError *error) {
        completion();
        if (success) {
            ProfileDescriptionViewController *controller = [[ProfileDescriptionViewController alloc]
                    initWithNibName:@"ProfileDescriptionViewController" bundle:nil];
            controller.calendarInfoDelegate = calendarModel;
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            [HSAlertViewController showWithMessage:@"Ошибка при загрузке событий календаря"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (void)processAuthorizationWithError: (NSError *)error {
    [HSAlertViewController showWithMessage:localizedDescriptionForParseError(error)];
}

- (void)specifyPlatformInfoForUser:(PFUser *)user {
    [user setObject:@"iphone" forKey:@"platform"];
}


@end
