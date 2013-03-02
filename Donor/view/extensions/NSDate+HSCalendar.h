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

/**
 * Returns new date object related to the same day but moved to the specified time.
 */
- (NSDate *)dateMovedToHour: (NSUInteger)hour minute: (NSUInteger)minute;

/**
 * Returns new date before current at the same time.
 */
- (NSDate *)yesterday;

/**
 * Returns new date after current at the same time.
 */
- (NSDate *)tomorrow;

@end
