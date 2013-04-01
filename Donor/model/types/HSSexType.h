//
//  HSSexType.h
//  Donor
//
//  Created by Sergey Seroshtan on 31.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Describes possible person sex values.
 */
typedef enum {
    HSSexType_Mail = 0,
    HSSexType_Femail
} HSSexType;

/**
 * Returns string representation of HSSexType set value in 3-letters format.
 */
NSString *sexToShortString(HSSexType sex);
