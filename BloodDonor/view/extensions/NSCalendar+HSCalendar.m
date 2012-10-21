//
//  NSCalendar+HSCalendar.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 21.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "NSCalendar+HSCalendar.h"

@implementation NSCalendar (HSCalendar)

- (NSDateComponents *)firstWeekdayComponentsForDate: (NSDate *)date {
    NSDateComponents *dateComponents = [self components: NSYearCalendarUnit | NSMonthCalendarUnit |
            NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate: date];

    // Set calendar to the first day of month
    NSDateComponents *result = [[NSDateComponents alloc] init];
    result.day = 1;
    result.month = dateComponents.month;
    result.year = dateComponents.year;
    result = [self components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
              NSWeekdayCalendarUnit fromDate: [self dateFromComponents:result]];
    
    // Set calendar day to the nearest monday in the past.
    const NSUInteger SUNDAY = 1;
    const NSUInteger MONDAY = 2;
    const NSUInteger DAYS_PER_WEEK = 7;
    NSUInteger weekday = result.weekday == SUNDAY ? DAYS_PER_WEEK  + 1 : result.weekday;
    result.day -= weekday - MONDAY;
    
    result = [self components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
              NSWeekdayCalendarUnit fromDate: [self dateFromComponents:result]];
    
    NSAssert(result.weekday == MONDAY, @"Weekday is not monday. Check algorithm.");
    return result;
}


@end
