//
//  NSCalendar+HSCalendar.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 21.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Provides some convinient methods for date calculations
 */
@interface NSCalendar (HSCalendar)

/**
 * Returns date components of first day (monday) in the month visible representation for the specified month (date).
 */
- (NSDateComponents *)firstWeekdayComponentsForDate: (NSDate *)date;

@end
