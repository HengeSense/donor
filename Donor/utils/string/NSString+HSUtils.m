//
//  NSString+HSAlertViewController.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 11.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "NSString+HSUtils.h"

@implementation NSString (HSUtils)

- (BOOL)isNotEmpty {
    return self.length > 0;
}

- (NSString *)capitalizedFirstLetterString {
    if (self.length == 0) {
        return self;
    }
    return [self stringByReplacingCharactersInRange:NSMakeRange(0,1)
        withString:[[self substringToIndex:1] capitalizedString]];
}

@end
