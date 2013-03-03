//
//  HSBloodRemoteEvent+LocalNotification_Protected.h
//  Donor
//
//  Created by Sergey Seroshtan on 02.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSBloodRemoteEvent.h"

@interface HSBloodRemoteEvent (LocalNotification_Protected)

/**
 * Subclass should implement this method to provide event specific alert body for reminder local notification.
 */
- (NSString *)alertBodyForReminderLocalNotification;

/**
 * Subclass should implement this method to provide event specific alert body for confirmation local notification.
 */
- (NSString *)alertBodyForConfirmationLocalNotification;

@end
