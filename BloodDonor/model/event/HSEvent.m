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

- (id)init {
    if (self = [super init]) {
        self.scheduledDate = [NSDate date];
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat: @"dd MMM yyyy HH:mm"];
    }
    return self;
}

#pragma mark - Prettify methods
- (NSString *)formatScheduledDate {
    return [self.dateFormatter stringFromDate: self.scheduledDate];
}
@end
