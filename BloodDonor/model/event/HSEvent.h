//
//  HSEvent.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 18.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This class provides common behaviour for all calendar events.
 */
@interface HSEvent : NSObject

/// @name Properties

/**
 * Date when event should be scheduled.
 */
@property (nonatomic, strong) NSDate *scheduledDate;

/**
 * Common event date formatter. This property has default value, but it can be replaced.
 */
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

/// @name Initialization methods

/**
 * Create HSEvent with scheduledDate property set to NOW.
 */
- (id)init;

/// @name Prittify methods

/**
 * Returns scheduledDate property value (date) formated with dateFormatter.
 */
- (NSString *)formatScheduledDate;


@end
