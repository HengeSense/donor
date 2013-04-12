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

@interface HSItsBeta ()

+ (void) linkItsBeta:(UIViewController*)viewController player:(ItsBetaPlayer*)player user:(PFUser*)user objects:(NSArray*)objects completion:(void(^)(void))completion;
+ (void) giveGiveInstallAchievementItsBeta:(UIViewController*)viewController player:(ItsBetaPlayer*)player completion:(void(^)(void))completion;

@end

@implementation HSItsBeta

+ (void) assignItsBeta:(UIViewController*)viewController user:(PFUser*)user completion:(void(^)(void))completion {
    [ItsBeta playerLoginFacebookWithViewController:viewController
                                          callback:^(ItsBetaPlayer *player, NSError *error) {
                                              PFRelation* relation = [user relationforKey:@"ItsBeta"];
                                              [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                                  if(error == nil) {
                                                      [self linkItsBeta:viewController player:player user:user objects:objects completion:completion];
                                                  }
                                              }];
                                          }];
}

+ (void) linkItsBeta:(UIViewController*)viewController player:(ItsBetaPlayer*)player user:(PFUser*)user objects:(NSArray*)objects completion:(void(^)(void))completion {
    BOOL created = NO;
    PFObject* itsbeta = nil;
    if([objects count] > 0) {
        itsbeta = [objects lastObject];
    } else {
        itsbeta = [PFObject objectWithClassName:@"ItsBeta"];
        created = YES;
    }
    if([player isLogined] == YES) {
        [itsbeta setObject:[player typeString] forKey:@"type"];
        [itsbeta setObject:[player facebookId] forKey:@"facebookUserId"];
        [itsbeta setObject:[player facebookToken] forKey:@"facebookAccessToken"];
    } else {
        [itsbeta setObject:@"" forKey:@"type"];
    }
    [itsbeta saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded == YES) {
            if(created == YES) {
                [[user relationforKey:@"ItsBeta"] addObject:itsbeta];
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(succeeded == YES) {
                        [self giveGiveInstallAchievementItsBeta:viewController player:player completion:completion];
                    } else {
                        [HSAlertViewController showWithMessage:@"Ошибка привязки itsbeta"];
                    }
                }];
            } else {
                [self giveGiveInstallAchievementItsBeta:viewController player:player completion:completion];
            }
        } else {
            [HSAlertViewController showWithMessage:@"Ошибка привязки itsbeta"];
        }
    }];
}

+ (void) giveGiveInstallAchievementItsBeta:(UIViewController*)viewController player:(ItsBetaPlayer*)player completion:(void(^)(void))completion {
    if([player isLogined] == YES) {
        ItsBetaProject* project = [ItsBeta projectByName:@"donor"];
        ItsBetaObjectTemplate* objectTemplate = [ItsBeta objectTemplateByName:@"donorfriend" byProject:project];
        [ItsBeta playerGiveAchievementWithProject:project
                                   objectTemplate:objectTemplate
                                           params:nil
                                         callback:^(ItsBetaPlayer *player, NSString *object_id, NSError *error) {
                                             if(completion != nil) {
                                                 completion();
                                             }
                                             if(error == nil) {
                                                 HSItsBetaAchievementDetailViewController *controller = [HSItsBetaAchievementDetailViewController new];
                                                 if(controller != nil) {
                                                     controller.objectID = object_id;
                                                     [viewController.navigationController pushViewController:controller animated:YES];
                                                 }
                                             }
                                         }];
    } else {
        if(completion != nil) {
            completion();
        }
    }
}

+ (void) restoreItsBeta:(UIViewController*)viewController user:(PFUser*)user completion:(void(^)(void))completion {
    PFRelation* relation = [user relationforKey:@"ItsBeta"];
    [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error == nil) {
            PFObject* object = [objects lastObject];
            if(object != nil) {
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
                        if(completion != nil) {
                            completion();
                        }
                    break;
                }
            } else {
                [self assignItsBeta:viewController user:user completion:completion];
            }
        }
    }];
}

@end