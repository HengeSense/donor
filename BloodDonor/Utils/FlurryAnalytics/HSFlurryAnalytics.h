//
//  HSFlurryAnalytics.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 29.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSBloodRemoteEvent;
/**
 * This class provides convinient customized wrapper for Flurry Analytics library.
 */
@interface HSFlurryAnalytics : NSObject

/**
 * Creates and configures flurry with specified application id.
 */
+ (void)initWithAppId:(NSString *)appId;

+ (void)userRegistered;
+ (void)userLoggedIn;
+ (void)userLoggedOut;
+ (void)userUpdatedProfile;
+ (void)userCreatedCalendarEvent: (HSBloodRemoteEvent *)bloodRemoteEvent;
+ (void)userUpdatedCalendarEvent: (HSBloodRemoteEvent *)bloodRemoteEvent;
+ (void)userDeletedCalendarEvent: (HSBloodRemoteEvent *)bloodRemoteEvent;

@end
