//
//  HSSexType.m
//  Donor
//
//  Created by Sergey Seroshtan on 31.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSSexType.h"

NSString *sexToShortString(HSSexType sex) {
    switch (sex) {
        case HSSexType_Mail:
            return @"муж";
        case HSSexType_Femail:
            return @"жен";
        default:
            return @"";
    }
}
