//
//  HSNotificationEvent.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 18.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSEvent.h"

/**
 * This class provides information about events, about which user should be notified.
 */
@interface HSNotificationEvent : HSEvent

/**
 * The date and time when user should be notified.
 * If this value less than [NSEvent scheduledDate] user won't be notified.
 */
@property (nonatomic, strong) NSDate *notificationDate;

/**
 * Notification message that would be displayed for user.
 */
@property (nonatomic, strong) NSString *notificationMessage;

@end
