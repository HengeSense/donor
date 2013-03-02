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
 * Subclass should implement this method to provide event specific alett body for remind local notification.
 */
- (NSString *)alertBodyForRemindLocalNotification;

@end
