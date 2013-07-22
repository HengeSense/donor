//
//  HSFoursquareTip.h
//  Donor
//
//  Created by Sergey Seroshtan on 22.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HSFoursquareObject.h"
#import "HSFoursquareVenue.h"

@interface HSFoursquareTip : HSFoursquareObject

/// @name Accessors

/// @name Base
- (NSString *)canonicalUrl;
- (NSDate *)createdAt;
- (NSString *)text;

/// @name User
- (NSString *)userFirstName;
- (NSString *)userLastName;

/// @name Venue
- (HSFoursquareVenue *)venue;

@end
