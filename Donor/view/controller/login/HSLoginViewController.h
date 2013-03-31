//
//  HSLoginViewController.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 10.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class HSCalendarViewController;

/**
 * This is base class for all view controllers that provide login or registration.
 */
@interface HSLoginViewController : UIViewController

/// @name Protected methods
/**
 * This method is used be subclasses to handle successfull user authorization and load his calendar events.
 */
- (void)processAuthorizationSuccessWithUser:(PFUser *)user completion: (void(^)(void))completion;

/**
 * This method is used be subclasses to handle failed user authorization and show him an error.
 */
- (void)processAuthorizationWithError: (NSError *)error;

/**
 * Stores information about platform in the specified user's object.
 */
- (void)specifyPlatformInfoForUser:(PFUser *)user;

@end
