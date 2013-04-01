//
//  HSDevicePlatformType.m
//  Donor
//
//  Created by Sergey Seroshtan on 31.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSDevicePlatformType.h"

NSString *devicePlatformToString(HSDevicePlatformType devicePlatform) {
    switch (devicePlatform) {
        case HSDevicePlatformType_iPhone:
            return @"iphone";
        default:
            return @"";
    }
}

HSDevicePlatformType devicePlatformFromString(NSString *devicePlatformString) {
    if ([devicePlatformString isEqualToString:devicePlatformToString(HSDevicePlatformType_iPhone)]) {
        return HSDevicePlatformType_iPhone;
    } else {
        return HSDevicePlatformType_iPhone;
    }
}
