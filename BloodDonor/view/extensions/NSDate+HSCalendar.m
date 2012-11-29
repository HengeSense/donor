//
//  NSDate+HSCalendar.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 06.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "NSDate+HSCalendar.h"

@implementation NSDate (HSCalendar)

- (BOOL)isTheSameDay: (NSDate *)date {
    THROW_IF_ARGUMENT_NIL(date, @"date is not specified");

    NSCalendar *systemCalendar = [NSCalendar currentCalendar];
    int dateComponentsUnits = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponents = [systemCalendar components: dateComponentsUnits fromDate: date];
    NSDateComponents *selfDateComponents = [systemCalendar components: dateComponentsUnits fromDate: self];
    
    if ([selfDateComponents isEqual: dateComponents]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isBeforeDay: (NSDate *)date {
    THROW_IF_ARGUMENT_NIL(date, @"date is not specified");
    
    NSCalendar *systemCalendar = [NSCalendar currentCalendar];
    int dateComponentsUnits = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponents = [systemCalendar components: dateComponentsUnits fromDate: date];
    NSDateComponents *selfDateComponents = [systemCalendar components: dateComponentsUnits fromDate: self];
    
    NSDate *roundedSelfDate = [systemCalendar dateFromComponents: selfDateComponents];
    NSDate *roundedDate = [systemCalendar dateFromComponents: dateComponents];
    return roundedSelfDate.timeIntervalSince1970 < roundedDate.timeIntervalSince1970;
}

- (BOOL)isAfterDay:(NSDate *)date {
    THROW_IF_ARGUMENT_NIL(date, @"date is not specified");
    
    NSCalendar *systemCalendar = [NSCalendar currentCalendar];
    int dateComponentsUnits = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponents = [systemCalendar components: dateComponentsUnits fromDate: date];
    NSDateComponents *selfDateComponents = [systemCalendar components: dateComponentsUnits fromDate: self];
    
    NSDate *roundedSelfDate = [systemCalendar dateFromComponents: selfDateComponents];
    NSDate *roundedDate = [systemCalendar dateFromComponents: dateComponents];
    return roundedSelfDate.timeIntervalSince1970 > roundedDate.timeIntervalSince1970;
}

- (NSDate *)dateMovedToHour: (NSUInteger)hour minute: (NSUInteger)minute {
    int calendarUnits = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit |
                        NSMinuteCalendarUnit;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components: calendarUnits fromDate: self];
    
    dateComponents.hour = hour;
    dateComponents.minute = minute;
    
    return [[NSCalendar currentCalendar] dateFromComponents: dateComponents];
}

@end