//
//  HSFoursquare.h
//  Donor
//
//  Created by Sergey Seroshtan on 18.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * If success == YES, type of result paramter depends on certain operation,
 *     otherwise it contains HSFoursqaureError object, or nil.
 */
typedef void(^HSFoursquareCompletionType)(BOOL success, id result);

@class HSStationInfo;
@class HSStationReview;

/**
 * This is domain specific wrapper for Foursquare framework.
 */
@interface HSFoursquare : NSObject

/// @name Foursquare API
/**
 * Check whether user is authenticated or not.
 */
+ (BOOL)isUserAuthenticated;

/**
 * Make async loading of the specific station reviews,
 * If success - 'result' parameter of completion block is array of HSStationReview objects,
 *     otherwise HSFoursqaureError object.
 */
+ (void)getStationReviews:(HSStationInfo *)stationInfo completion:(HSFoursquareCompletionType)completion;

/**
 * Make async adding of the specific station review.
 * If success - 'result' parameter of completion block is nil.
 * If fail - HSFoursqaureError object or nil if user cancel authentication.
 */
+ (void)addStationReview:(HSStationReview *)stationReview toStation:(HSStationInfo *)stationInfo
         completion:(HSFoursquareCompletionType)completion;

@end
