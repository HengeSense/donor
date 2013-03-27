//
//  HSNotification.m
//  Donor
//
//  Created by Sergey Seroshtan on 25.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSNotification.h"

#import "HSNotificationEvent.h"

@implementation HSNotification

#pragma mark - Creation helpers
+ (HSNotification *)notificationWithEvent:(HSNotificationEvent *)event nature:(HSNotificationNatureType)nature
        source:(HSNotificationSourceType)source {
    THROW_IF_ARGUMENT_NIL(event);
    HSNotification *notification = [[HSNotification alloc] init];
    notification.event = event;
    notification.nature = nature;
    notification.source = source;
    return notification;
}

+ (HSNotification *)localNotificationWithEvent:(HSNotificationEvent *)event nature:(HSNotificationNatureType)nature {
    return [HSNotification notificationWithEvent:event nature:nature source:HSNotificationSourceType_Local];
}

+ (HSNotification *)remoteNotificationWithEvent:(HSNotificationEvent *)event nature:(HSNotificationNatureType)nature {
    return [HSNotification notificationWithEvent:event nature:nature source:HSNotificationSourceType_Remote];
}

#pragma mark - Information accessors
- (BOOL)isReminder {
    return self.nature == HSNotificationNatureType_Reminder;
}

- (BOOL)isConfirmation {
    return self.nature == HSNotificationNatureType_Confirmation;
}

- (BOOL)isLocal {
    return self.source == HSNotificationSourceType_Local;
}

- (BOOL)isRemote {
    return self.source == HSNotificationSourceType_Remote;
}

@end
