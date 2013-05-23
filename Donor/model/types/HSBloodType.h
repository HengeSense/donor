//
//  HSBloodType.h
//  Donor
//
//  Created by Sergey Seroshtan on 31.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Blood groups definition.
 */
typedef enum {
    HSBloodGroupType_Unknown = -1,
    HSBloodGroupType_O = 0,
    HSBloodGroupType_A = 1,
    HSBloodGroupType_B = 2,
    HSBloodGroupType_AB = 3
} HSBloodGroupType;

/**
 * Blood Rh definition.
 */
typedef enum {
    HSBloodRhType_Unknown = -1,
    HSBloodRhType_Positive = 0,
    HSBloodRhType_Negative = 1
} HSBloodRhType;

/**
 * Returns string representation of HSBloodGroupType set value.
 */
NSString *bloodGroupToString(HSBloodGroupType bloodGroup);

/**
 * Returns string representation of HSBloodRhType set value.
 */
NSString *bloodRhToString(HSBloodRhType bloodRh);
