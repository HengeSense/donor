//
//  HSFoursquareVenue.h
//  Donor
//
//  Created by Sergey Seroshtan on 18.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HSFoursquareObject.h"

@interface HSFoursquareVenue : HSFoursquareObject

/// @name Accessors
/// @name Common
- (NSString *)name;
- (NSString *)canonicalUrl;

/// @name Location
- (NSNumber *)lat;
- (NSNumber *)lon;
- (NSString *)address;
- (NSString *)city;
- (NSString *)country;

@end
