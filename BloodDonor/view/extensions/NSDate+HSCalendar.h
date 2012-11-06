//
//  NSDate+HSCalendar.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 06.11.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HSCalendar)

/**
 * Compares self and specified dates ignoring time.
 * @return YES if both date have same year, month and day
 */
-(BOOL)isTheSameDay: (NSDate *)date;

/**
 * Compares self and specified dates ignoring time.
 * @return YES if self date is before specified date
 */
- (BOOL)isBeforeDay: (NSDate *)date;

/**
 * Compares self and specified dates ignoring time.
 * @return YES if self date is after specified date
 */
- (BOOL)isAfterDay: (NSDate *)date;

@end
