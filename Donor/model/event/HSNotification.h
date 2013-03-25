//
//  HSNotification.h
//  Donor
//
//  Created by Sergey Seroshtan on 25.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSNotificationEvent;

/// @name Types definition
/**
 * This type describes nature of the notification: is it reminder event or is it confirmation event.
 */
typedef enum {
    HSNotificationNatureType_Reminder = 0,
    HSNotificationNatureType_Confirmation
} HSNotificationNatureType;

/**
 * This type describes initial source of the notifiction: local notification or push notification.
 */
typedef enum {
    HSNotificationSourceType_Local = 0,
    HSNotificationSourceType_Remote
} HSNotificationSourceType;

/**
 * This class encapsulates information about notification and it's nature.
 */
@interface HSNotification : NSObject

/// @name Accessors
@property (nonatomic, strong) HSNotificationEvent *event;
@property (nonatomic, assign) HSNotificationNatureType nature;
@property (nonatomic, assign) HSNotificationSourceType source;

/// @name Creation helpers
/**
 * Creates notification with specified event, nature and source.
 */
+ (HSNotification *)notificationWithEvent:(HSNotificationEvent *)event nature:(HSNotificationNatureType)nature
        source:(HSNotificationSourceType)source;

/**
 * Creates notification with specified event, nature and predefined source (HSNotificationSourceType_Local).
 */
+ (HSNotification *)localNotificationWithEvent:(HSNotificationEvent *)event nature:(HSNotificationNatureType)nature;

/**
 * Creates notification with specified event, nature and predefined source (HSNotificationSourceType_Remote).
 */
+ (HSNotification *)remoteNotificationWithEvent:(HSNotificationEvent *)event nature:(HSNotificationNatureType)nature;

/// @name Information accessors
/**
 * Returns whether notification nature is HSNotificationType_Reminder.
 */
- (BOOL)isReminder;

/**
 * Returns whether notification nature is HSNotificationType_Confirmation.
 */
- (BOOL)isConfirmation;

/**
 * Returns whether notification is local notification.
 */
-(BOOL)isLocal;

/**
 * Returns whether notification is remote
 */
- (BOOL)isRemote;

@end
