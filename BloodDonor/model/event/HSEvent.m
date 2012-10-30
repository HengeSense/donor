//
//  HSEvent.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 18.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSEvent.h"

@implementation HSEvent

#pragma mark - Initializing

- (id) init {
    if (self = [super init]) {
        self.scheduledDate = [NSDate date];
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    }
    return self;
}

@end
