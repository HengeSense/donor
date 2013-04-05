//
//  HSLoginViewController.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 10.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSLoginViewController.h"
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

- (void)processAuthorizationSuccessWithUser:(PFUser *)user completion: (void(^)(void))completion {
    if (user.isNew) {
        [HSFlurryAnalytics userRegistered];
    }
    [HSFlurryAnalytics userLoggedIn];
    [[HSMailChimp sharedInstance] subscribeOrUpdateUser:user];
    
    HSCalendar *calendarModel = [HSCalendar sharedInstance];
    [calendarModel unlockModelWithUser:user];
    [calendarModel pullEventsFromServer:^(BOOL success, NSError *error) {
        [ItsBeta playerLoginFacebookWithViewController:self
                                              callback:^(ItsBetaPlayer *player, NSError *error) {
                                                  [self giveInstallAchievement:^{
                                                      completion();
                                                      if(error != nil) {
                                                          [HSAlertViewController showWithMessage:@"Ошибка при авторизации в itsbeta"];
                                                          [self.navigationController popToRootViewControllerAnimated:YES];
                                                      } else {
                                                          if (success == YES) {
                                                              HSProfileDescriptionViewController *controller = [[HSProfileDescriptionViewController alloc] initWithNibName:@"HSProfileDescriptionViewController" bundle:nil];
                                                              controller.calendarInfoDelegate = calendarModel;
                                                              [self.navigationController pushViewController:controller animated:YES];
                                                          } else {
                                                              [HSAlertViewController showWithMessage:@"Ошибка при загрузке событий календаря"];
                                                              [self.navigationController popToRootViewControllerAnimated:YES];
                                                          }
                                                      }
                                                  }];
                                              }];
    }];
}

- (void)processAuthorizationWithError: (NSError *)error {
    [HSAlertViewController showWithMessage:[HSModelCommon localizedDescriptionForParseError:error]];
}

- (void)specifyPlatformInfoForUser:(PFUser *)user {
    HSUserInfo *userInfo = [[HSUserInfo alloc] initWithUser:user];
    userInfo.devicePlatform = HSDevicePlatformType_iPhone;
    [userInfo applyChanges];
}

- (void)giveInstallAchievement:(void(^)(void))completion {
    ItsBetaProject* project = [ItsBeta projectByName:@"donor"];
    ItsBetaObjectTemplate* objectTemplate = [ItsBeta objectTemplateByName:@"donorfriend" byProject:project];
    [ItsBeta playerGiveAchievementWithProject:project
                               objectTemplate:objectTemplate
                                       params:nil
                                     callback:^(ItsBetaPlayer *player, NSString *object_id, NSError *error) {
                                         [ItsBeta synchronizePlayerWithProject:project];
                                         completion();
                                     }];
}

@end
