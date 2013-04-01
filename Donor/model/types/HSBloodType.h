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
    HSBloodGroupType_O = 0,
    HSBloodGroupType_A,
    HSBloodGroupType_B,
    HSBloodGroupType_AB
} HSBloodGroupType;

/**
 * Blood Rh definition.
 */
typedef enum {
    HSBloodRhType_Positive = 0,
    HSBloodRhType_Negative
} HSBloodRhType;

/**
 * Returns string representation of HSBloodGroupType set value.
 */
NSString *bloodGroupToString(HSBloodGroupType bloodGroup);

/**
 * Returns string representation of HSBloodRhType set value.
 */
NSString *bloodRhToString(HSBloodRhType bloodRh);
