//
//  NSString+HSAlertViewController.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 11.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFUser;

@interface HSItsBeta: NSObject

+ (void) assignItsBeta:(UIViewController*)viewController user:(PFUser*)user completion:(void(^)(void))completion;
+ (void) restoreItsBeta:(UIViewController*)viewController user:(PFUser*)user completion:(void(^)(void))completion;

@end
