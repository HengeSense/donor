//
//  HSNotificationEvent.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 18.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSEvent.h"

/// @name Constatns section

extern NSString * const kNotificationEventAlertActionDefault;
extern NSString * const kLocalNotificationUserInfoKey_ClassName;
/**
 * This class provides information about events, which user should be notified.
 */
@interface HSNotificationEvent : HSEvent

/// @name Public configuration properties.

/**
 * Defines a date when user will be notified.
 * This property is used in [self scheduleReminderLocalNotificationAtDate:] in case
 *     if localNotificationFireDate parameter is nil.
 * This property can also be nil. In this case correspond methods use default values for fireDate.
 */
@property (nonatomic, strong) NSDate *reminderFireDate;

/// @name Public methods.

/**
 * Returns fireDate property value (date) formated with dateFormatter.
 */
- (NSString *)formattedReminderFireDate;

/**
 * Schedules a local notification for delivery at specified date and time.
 *
 * @param date - the date and time when user should be notified.
 * @param title - notification title that would be displayed for user or nil.
 * @param message - notification message that would be displayed for user or nil.
 * @param userInfo - custom user-specific data passed to the local notification's payload.
 */
- (void)scheduleLocalNotificationAtDate:(NSDate *)date withAlertAction:(NSString *)alertAction
        alertBody:(NSString *)alertBody userInfo:(NSDictionary *)userInfo;

/**
 * Cancels the delivery of all scheduled local notifications.
 * Delegates functionality ot [UIApplication cancelAllLocalNotifications].
 */
+ (void)cancelAllLocalNotifications;

/// @name Protected helpers.
/**
 * Returns YES if local notification belongs to this object.
 * Base implementation checks only class belongings.
 */
- (BOOL)isSelfLocalNotification:(UILocalNotification *)localNotification;

/**
 * Returns base userInfo dictionary for local notification.
 */
- (NSDictionary *)localNotificationBaseUserInfo;

/**
 * Returns base userInfo dictionary for reminder local notification.
 */
- (NSDictionary *)reminderLocalNotificationBaseUserInfo;

/**
 * Returns base userInfo dictionary for confirmation local notification.
 */
- (NSDictionary *)confirmationLocalNotificationBaseUserInfo;

/**
 * Checks whether event has scheduled reminder local notification.
 */
- (BOOL)hasScheduledReminderLocalNotification;

/**
 * Checks whether event has scheduled confirmation local notification.
 */
- (BOOL)hasScheduledConfirmationLocalNotification;

/**
 * Cancels scheduled local notifications (reminder or/and confirmation).
 * Uses method isSelfLocalNotification: to determine wheter or not make canceling.
 */
- (void)cancelScheduledLocalNotifications;

/// @name Abstract methods.
/**
 * Provides information about default value of reminderFireDate.
 * Should be overriden in subclasses.
 */
- (NSDate *)reminderFireDateDefault;

/**
 * Schedules reminder local notification for delivery at specified date and time.
 * Should be overriden in subclasses.
 */
- (void)scheduleReminderLocalNotificationAtDate:(NSDate *)fireDate;

/**
 * Schedules confirmation local notification for delivery at hardcoded time in the same day.
 * Should be overriden in subclasses.
 */
- (void)scheduleConfirmationLocalNotification;

@end
