//
//  HSDevicePlatformType.h
//  Donor
//
//  Created by Sergey Seroshtan on 31.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Device platform set type definition.
 */
typedef enum {
    HSDevicePlatformType_iPhone = 0
} HSDevicePlatformType;

/**
 * Returns string representation of HSDevicePlatformType set value.
 */
NSString *devicePlatformToString(HSDevicePlatformType devicePlatform);

/**
 * Returns HSDevicePlatformType set value from it string representation.
 * If string is unknown HSDevicePlatformType_iPhone value will be returned.
 */
HSDevicePlatformType devicePlatformFromString(NSString *devicePlatformString);
