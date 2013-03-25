//
//  HSCalendarEventNotificationHandler.h
//  Donor
//
//  Created by Sergey Seroshtan on 16.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSNotification.h"
/**
 * This protocol should be implemented by classes, which can handle local and remote notifications.
 */
@protocol HSCalendarEventNotificationHandler <NSObject>
- (void)handleNotification:(HSNotification *)notificationEvent;
@end

