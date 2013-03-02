//
//  HSNotificationEvent.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 18.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSEvent.h"

/// @name Constatns section

extern NSString *kNotificationEventAlertActionDefault;
extern NSString *kNotificationEventUserInfoEventClassNameKey;

/**
 * This class provides information about events, which user should be notified.
 */
@interface HSNotificationEvent : HSEvent

/// @name Public info properties.
/**
 * Schedules a local notification for delivery at specified date and time.
 *
 * @param date - the date and time when user should be notified.
 * @param title - notification title that would be displayed for user.
 * @param message - notification message that would be displayed for user.
 */
- (void)scheduleLocalNotificationAtDate:(NSDate *)date withAlertAction:(NSString *)title alertBody:(NSString *)message;

/**
 * Cancels the delivery of all scheduled local notifications.
 * Delegates functionality ot [UIApplication cancelAllLocalNotifications].
 */
+ (void)cancelAllLocalNotifications;

@end
