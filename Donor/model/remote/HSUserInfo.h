//
//  HSUserInfo.h
//  Donor
//
//  Created by Sergey Seroshtan on 30.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HSSexType.h"
#import "HSBloodType.h"
#import "HSDevicePlatformType.h"

@class PFUser;

/**
 * This class provides information that is stored in PFUser object.
 */
@interface HSUserInfo : NSObject

/// @name Init properies
@property (nonatomic, strong, readonly) PFUser *user;

/// @name Info properties
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *secondName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, assign) HSBloodGroupType *bloodGroup;
@property (nonatomic, assign) HSBloodRhType *bloodRh;
@property (nonatomic, assign) HSSexType sex;
@property (nonatomic, assign) HSDevicePlatformType devicePlatform;

/// @name Initialization
- (id)initWithUser:(PFUser *)user;

/// @name Aply changes.
/**
 * Moves changes from properties to the remote user object if it was specified in [HSUserInfo initWithUser:].
 */
- (void)applyChanges;

@end
