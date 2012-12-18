//
//  HSFlurryAnalytics.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 29.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSFlurryAnalytics.h"

#import <Parse/Parse.h>
#import "Flurry.h"
#import "HSBloodRemoteEvent.h"
#import "HSBloodDonationEvent.h"
#import "HSBloodTestsEvent.h"

#pragma mark - Flurry event names
static NSString * const kUserRegisteredFlurryEvent = @"User_Registered";
static NSString * const kUserLoggedInFlurryEvent = @"User_Logged_In";
static NSString * const kUserLoggedOutFlurryEvent = @"User_Logged_Out";
static NSString * const kUserUpdatedProfileFlurryEvent = @"User_Updated_Profile";
static NSString * const kUserCalendarFlurryEvent = @"User_Made_Calendar_Action";

#pragma mark - Flurry event parameters
static NSString * const kUserParseId = @"User_Parse_ID";
static NSString * const kUserPlatform = @"User_Platform";
static NSString * const kBloodEvent = @"Blood_Event";
static NSString * const kBloodDonationType = @"Blood_Donation_Type";
static NSString * const kBloodDonationAction = @"Blood_Donation_Action";

#pragma mark - Static values
static NSString * const kUserPlatfrormValue = @"iphone";
static NSString * const kBloodDonationActionCreated = @"Created";
static NSString * const kBloodDonationActionUpdated = @"Updated";
static NSString * const kBloodDonationActionDeleted = @"Deleted";

@implementation HSFlurryAnalytics

+(void)initWithAppId:(NSString *)appId {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    [Flurry setAppVersion: [NSString stringWithFormat:@"%@ (%@)", majorVersion, minorVersion]];
    [Flurry startSession:appId];
}

+ (void)userRegistered {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
            [PFUser currentUser].objectId, kUserParseId,
            kUserPlatfrormValue, kUserPlatform,
            nil];
    [Flurry logEvent:kUserRegisteredFlurryEvent withParameters:parameters];
    [TestFlight passCheckpoint:kUserRegisteredFlurryEvent];
}

+ (void)userLoggedIn {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
            [PFUser currentUser].objectId, kUserParseId,
            kUserPlatfrormValue, kUserPlatform,
            nil];
    [Flurry logEvent:kUserLoggedInFlurryEvent withParameters:parameters];
    [TestFlight passCheckpoint:kUserLoggedInFlurryEvent];
}

+ (void)userLoggedOut {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
            [PFUser currentUser].objectId, kUserParseId,
            kUserPlatfrormValue, kUserPlatform,
            nil];
    [Flurry logEvent:kUserLoggedOutFlurryEvent withParameters:parameters];
    [TestFlight passCheckpoint:kUserLoggedOutFlurryEvent];

}

+ (void)userUpdatedProfile {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
            [PFUser currentUser].objectId, kUserParseId,
            kUserPlatfrormValue, kUserPlatform,
            nil];
    [Flurry logEvent:kUserUpdatedProfileFlurryEvent withParameters:parameters];
    [TestFlight passCheckpoint:kUserUpdatedProfileFlurryEvent];
}

+ (void)userCreatedCalendarEvent: (HSBloodRemoteEvent *)bloodRemoteEvent {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
            [PFUser currentUser].objectId, kUserParseId,
            kUserPlatfrormValue, kUserPlatform,
            [self eventStringFromBloodRemoteEvent:bloodRemoteEvent], kBloodEvent,
            [self donationTypeStringFromBloodRemoteEvent:bloodRemoteEvent], kBloodDonationType,
            kBloodDonationActionCreated, kBloodDonationAction,
            nil];
    [Flurry logEvent:kUserCalendarFlurryEvent withParameters:parameters];
    [TestFlight passCheckpoint:kUserCalendarFlurryEvent];
}

+ (void)userUpdatedCalendarEvent: (HSBloodRemoteEvent *)bloodRemoteEvent {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
            [PFUser currentUser].objectId, kUserParseId,
            kUserPlatfrormValue, kUserPlatform,
            [self eventStringFromBloodRemoteEvent:bloodRemoteEvent], kBloodEvent,
            [self donationTypeStringFromBloodRemoteEvent:bloodRemoteEvent], kBloodDonationType,
            kBloodDonationActionUpdated, kBloodDonationAction,
            nil];
    [Flurry logEvent:kUserCalendarFlurryEvent withParameters:parameters];
    [TestFlight passCheckpoint:kUserCalendarFlurryEvent];
}

+ (void)userDeletedCalendarEvent: (HSBloodRemoteEvent *)bloodRemoteEvent {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
            [PFUser currentUser].objectId, kUserParseId,
            kUserPlatfrormValue, kUserPlatform,
            [self eventStringFromBloodRemoteEvent:bloodRemoteEvent], kBloodEvent,
            [self donationTypeStringFromBloodRemoteEvent:bloodRemoteEvent], kBloodDonationType,
            kBloodDonationActionDeleted, kBloodDonationAction,
            nil];
    [Flurry logEvent:kUserCalendarFlurryEvent withParameters:parameters];
    [TestFlight passCheckpoint:kUserCalendarFlurryEvent];
}

+ (NSString *)eventStringFromBloodRemoteEvent: (HSBloodRemoteEvent *)bloodRemoteEvent {
    if ([bloodRemoteEvent isKindOfClass:[HSBloodDonationEvent class]]) {
        return @"Donation";
    } else if ([bloodRemoteEvent isKindOfClass:[HSBloodTestsEvent class]]) {
        return @"Analysis";
    } else {
        return @"Undefined";
    }
}

+ (NSString *)donationTypeStringFromBloodRemoteEvent: (HSBloodRemoteEvent *)bloodRemoteEvent {
    if (![bloodRemoteEvent isKindOfClass:[HSBloodDonationEvent class]]) {
        return @"";
    }
    
    HSBloodDonationEvent *donationEvent = (HSBloodDonationEvent *)bloodRemoteEvent;
    switch (donationEvent.bloodDonationType) {
        case HSBloodDonationType_Blood:
            return @"Whole blood";
        case HSBloodDonationType_Granulocytes:
            return @"Granulocytes";
        case HSBloodDonationType_Plasma:
            return @"Plasma";
        case HSBloodDonationType_Platelets:
            return @"Platelets";
        default:
            return @"Undefined";
    }
}

@end
