//
//  NSString+HSAlertViewController.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 11.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSItsBeta.h"

#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "HSAlertViewController.h"
#import "HSItsBetaAchievementDetailViewController.h"
#import "ItsBeta.h"

@implementation HSItsBeta

+ (void) assignItsBeta:(UIViewController*)viewController user:(PFUser*)user completion:(void(^)(void))completion {
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:viewController.navigationController.view animated: YES];
    [ItsBeta playerLoginFacebookWithViewController:viewController
                                          callback:^(ItsBetaPlayer *player, NSError *error) {
                                              ItsBetaProject* project = [ItsBeta projectByName:@"donor"];
                                              ItsBetaObjectTemplate* objectTemplate = [ItsBeta objectTemplateByName:@"donorfriend" byProject:project];
                                              [ItsBeta playerGiveAchievementWithProject:project
                                                                         objectTemplate:objectTemplate
                                                                                 params:nil
                                                                               callback:^(ItsBetaPlayer *player, NSString *object_id, NSError *error) {
                                                                                   if(error == nil) {
                                                                                       PFObject* itsbeta = [PFObject objectWithClassName:@"ItsBeta"];
                                                                                       [itsbeta setObject:[player typeToString] forKey:@"type"];
                                                                                       [itsbeta setObject:[player facebookId] forKey:@"facebookUserId"];
                                                                                       [itsbeta setObject:[player facebookToken] forKey:@"facebookAccessToken"];
                                                                                       [user setObject:itsbeta forKey:@"ItsBeta"];
                                                                                       [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                                                           if(succeeded == YES) {
                                                                                               HSItsBetaAchievementDetailViewController *controller = [HSItsBetaAchievementDetailViewController new];
                                                                                               if(controller != nil) {
                                                                                                   controller.objectID = object_id;
                                                                                                   [viewController.navigationController pushViewController:controller animated:YES];
                                                                                               }
                                                                                               [progressHud hide:YES];
                                                                                               completion();
                                                                                           } else {
                                                                                               [HSAlertViewController showWithMessage:@"Ошибка привязки itsbeta"];
                                                                                               [progressHud hide:YES];
                                                                                           }
                                                                                       }];
                                                                                   } else {
                                                                                       [progressHud hide:YES];
                                                                                   }
                                                                               }];
                                          }];
}

+ (void) restoreItsBeta:(UIViewController*)viewController user:(PFUser*)user completion:(void(^)(void))completion {
    completion();
}

@end
