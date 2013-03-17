//
//  HSCalendarEventNotificationHandler.h
//  Donor
//
//  Created by Sergey Seroshtan on 16.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSNotificationEvent.h"
/**
 * This protocol should be implemented by classes, which can handle local and remote notifications.
 */
@protocol HSCalendarEventNotificationHandler <NSObject>
- (void)handleNotificationWithEvent:(HSNotificationEvent *)notificationEvent;
@end

