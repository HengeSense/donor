//
//  HSNotificationEvent.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 18.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSNotificationEvent.h"

NSString *kNotificationEventAlertActionDefault = @"Open";
NSString * const kLocalNotificationUserInfoKey_ClassName = @"eventClassName";

@implementation HSNotificationEvent

- (void)scheduleLocalNotificationAtDate:(NSDate *)date withAlertAction:(NSString *)alertAction
        alertBody:(NSString *)alertBody userInfo:(NSDictionary *)userInfo {
    THROW_IF_ARGUMENT_NIL_2(date);

    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = date;
    notification.alertBody = alertBody;
    notification.alertAction = alertAction;
    notification.userInfo = userInfo;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

+ (void)cancelAllLocalNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)scheduleReminderLocalNotificationAtDate:(NSDate *)fireDate {
    THROW_UNIMPLEMENTED_EXCEPTION;
}

- (void)scheduleConfirmationLocalNotificationAtDate:(NSDate *)fireDate {
    THROW_UNIMPLEMENTED_EXCEPTION;
}

- (void)cancelScheduledLocalNotification {
    THROW_UNIMPLEMENTED_EXCEPTION;
}

@end
