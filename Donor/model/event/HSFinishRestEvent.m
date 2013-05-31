//
//  HSFinishRestEvent.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 19.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSFinishRestEvent.h"
#import "NSDate+HSCalendar.h"

/**
 * This event contains information about finishing donor's rest period after previous blood donation.
 */
@implementation HSFinishRestEvent

- (NSDate *)reminderFireDateDefault {
    return [self.scheduleDate dateMovedToHour:17 minute:45];
}

- (void)scheduleConfirmationLocalNotification {
    // Do nothing
}

- (void)scheduleReminderLocalNotificationAtDate:(NSDate *)fireDate {
    if ([self hasScheduledReminderLocalNotification]) {
        return;
    }

    // Set default value
    NSDate *correctedFireDate = [self reminderFireDateDefault];
    if (fireDate != nil) {
        correctedFireDate = fireDate;
    } else if (self.reminderFireDate != nil) {
        correctedFireDate = self.reminderFireDate;
    }
    self.reminderFireDate = correctedFireDate;
            
    [super scheduleLocalNotificationAtDate:correctedFireDate withAlertAction:nil
            alertBody:bloodDonationTypeToFinishRestEventMessage(self.bloodDonationType)
            userInfo:[self reminderLocalNotificationBaseUserInfo]];
}

#pragma mark - HSUIDProvider protocol implementation
- (NSUInteger)uid {
    NSUInteger prime = 31;
    NSUInteger result = [super uid];
    
    result = prime * result + self.bloodDonationType;
    
    return result;
}

@end
