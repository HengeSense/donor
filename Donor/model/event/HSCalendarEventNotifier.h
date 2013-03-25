//
//  HSCalendarEventNotifier.h
//  Donor
//
//  Created by Sergey Seroshtan on 11.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSCalendarEventNotificationHandler.h"

@class HSNotification;

/**
 * Block type, that can handle HSNotificationEvent object.
 *    It's alternative usage of HSCalendarEventNotificationHandler protocol.
 */
typedef void(^HSCalendarEventNotificationHandlerBlock)(HSNotification *notification);

/**
 * Manages notification events' handlers, and make transformation from UILocalNotification objects to
 *     HSNotificationEvent objects, and than transfer them to handlers.
 */
@interface HSCalendarEventNotifier : NSObject

/// @name Notification handlers management
/**
 * Adds specifed notification handler to the notifier. If specified handler exists, then do nothing.
 */
- (void)addNotificationHandler:(id<HSCalendarEventNotificationHandler>)notificationHandler;

/**
 * Adds specifed notification handler block to the notifier. If specified handler exists, then do nothing.
 */
- (void)addNotificationHandlerBlock:(HSCalendarEventNotificationHandlerBlock)notificationHandlerBlock;

/**
 * Removes specifed notification handler from the notifier. If specified handler does not exist, then do nothing.
 */
- (void)removeNotificationHandler:(id<HSCalendarEventNotificationHandler>)notificationHandler;

/**
 * Removes specifed notification handler block from the notifier. If specified handler does not exist, then do nothing.
 */
- (void)removeNotificationHandlerBlock:(HSCalendarEventNotificationHandlerBlock)notificationHandlerBlock;

/// @name Notification events processing
/**
 * Transform local notification object to the correspond HSNotificationEvent object, and invokes
 *     [HSCalendarEventNotificationHandler handleNotificationWithEvent:] for all handlers and handler blocks.
 */
- (void)processLocalNotification:(UILocalNotification *)localNotification;

@end
