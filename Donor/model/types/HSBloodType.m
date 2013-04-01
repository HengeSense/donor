//
//  HSBloodType.m
//  Donor
//
//  Created by Sergey Seroshtan on 31.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSBloodType.h"

NSString *bloodGroupToString(HSBloodGroupType bloodGroup) {
    switch (bloodGroup)
    {
        case HSBloodGroupType_O:
            return @"O(I)";
        case HSBloodGroupType_A:
            return @"A(II)";
        case HSBloodGroupType_B:
            return @"B(III)";
        case HSBloodGroupType_AB:
            return @"AB(IV)";
        default:
            return @"";
    }
    
}

NSString *bloodRhToString(HSBloodRhType bloodRh) {
    switch (bloodRh) {
        case HSBloodRhType_Positive:
            return @"RH+";
        case HSBloodRhType_Negative:
            return @"RH-";
        default:
            return @"";
    }
}
