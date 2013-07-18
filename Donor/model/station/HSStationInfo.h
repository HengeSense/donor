//
//  HSStationInfo.h
//  Donor
//
//  Created by Sergey Seroshtan on 19.05.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

/**
 * Value-object class for handling information about blood station (YAStation object representation from parse.com).
 */
@interface HSStationInfo : NSObject <NSCoding>

/// @name Initialization
- (id)initWithRemoteStation:(PFObject *)station;

/**
 * Update object with remote representation
 */
- (void)updateWithRemoteStation:(PFObject *)station;

/// @name PFObject duplicate properties.
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

/// @name Custom properties (should be equal to remote field keys)
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSNumber *district_id;
@property (nonatomic, strong) NSString *district_name;
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *region_id;
@property (nonatomic, strong) NSString *region_name;
@property (nonatomic, strong) NSString *shortaddress;
@property (nonatomic, strong) NSString *site;
@property (nonatomic, strong) NSString *town;
@property (nonatomic, strong) NSString *work_time;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *chief;

/// @name Dynamic properties
@property (nonatomic, strong) NSNumber *distance;

@end
