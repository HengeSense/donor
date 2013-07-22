//
//  HSFoursquare.h
//  Donor
//
//  Created by Sergey Seroshtan on 18.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HSFoursquareCompletionType)(BOOL success, id result);

@class HSStationInfo;

/**
 * This is domain specific wrapper for Foursquare framework.
 */
@interface HSFoursquare : NSObject

+ (id)sharedInstance;

- (void)getStationReviews:(HSStationInfo *)stationInfo completion:(HSFoursquareCompletionType)completion;

@end
