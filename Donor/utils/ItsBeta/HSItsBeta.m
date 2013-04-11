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
                                                                                       [itsbeta setObject:[player typeString] forKey:@"type"];
                                                                                       [itsbeta setObject:[player facebookId] forKey:@"facebookUserId"];
                                                                                       [itsbeta setObject:[player facebookToken] forKey:@"facebookAccessToken"];
                                                                                       [itsbeta saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                                                           if(succeeded == YES) {
                                                                                               PFRelation* relation = [user relationforKey:@"ItsBeta"];
                                                                                               [relation addObject:itsbeta];
                                                                                               [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                                                                   if(succeeded == YES) {
                                                                                                       HSItsBetaAchievementDetailViewController *controller = [HSItsBetaAchievementDetailViewController new];
                                                                                                       if(controller != nil) {
                                                                                                           controller.objectID = object_id;
                                                                                                           [viewController.navigationController pushViewController:controller animated:YES];
                                                                                                       }
                                                                                                       if(completion != nil) {
                                                                                                           completion();
                                                                                                       }
                                                                                                   } else {
                                                                                                       [HSAlertViewController showWithMessage:@"Ошибка привязки itsbeta"];
                                                                                                   }
                                                                                               }];
                                                                                           } else {
                                                                                               [HSAlertViewController showWithMessage:@"Ошибка привязки itsbeta"];
                                                                                           }
                                                                                       }];
                                                                                   }
                                                                               }];
                                          }];
}

+ (void) restoreItsBeta:(UIViewController*)viewController user:(PFUser*)user completion:(void(^)(void))completion {
    PFRelation* relation = [user objectForKey:@"ItsBeta"];
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error == nil) {
            PFObject* object = [objects lastObject];
            ItsBetaPlayer* player = [[ItsBeta sharedItsBeta] player];
            [player setTypeString:[object objectForKey:@"type"]];
            switch([player type]) {
                case ItsBetaPlayerTypeFacebook: {
                    [ItsBeta playerLoginWithFacebookId:[object objectForKey:@"facebookUserId"]
                                         facebookToken:[object objectForKey:@"facebookAccessToken"]
                                              callback:^(ItsBetaPlayer *player, NSError *error) {
                                                  if(error == nil) {
                                                      if(completion != nil) {
                                                          completion();
                                                      }
                                                  }
                                              }];
                }
                break;
                default:
                break;
            }
        }
    }];
}

@end
