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

#pragma mark - Protected interface implementation
- (void)scheduleConfirmationLocalNotificationAtDate:(NSDate *)fireDate {
    // Do nothing
}

- (void)scheduleReminderLocalNotificationAtDate:(NSDate *)fireDate {

    // Set default value
    NSDate *correctedFireDate = [[self.scheduledDate dayBefore] dateMovedToHour:12 minute:00];
    if (fireDate != nil) {
        correctedFireDate = fireDate;
    } else if (self.fireDate != nil) {
        correctedFireDate = self.fireDate;
    }
            
    NSString *bloodDonationTypeString = [bloodDonationTypeToString(self.bloodDonationType) lowercaseString];
    NSDictionary *userInfo = @{};

    [super scheduleLocalNotificationAtDate:correctedFireDate withAlertAction:nil
            alertBody:[NSString stringWithFormat:@"Можно сдать %@.", bloodDonationTypeString] userInfo:userInfo];
}

- (void)cancelScheduledLocalNotification {
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSPredicate *idPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        UILocalNotification *candidate = evaluatedObject;
        NSString *className = [candidate.userInfo objectForKey:kLocalNotificationUserInfoKey_ClassName];
        return [className isEqualToString:NSStringFromClass(self.class)];
    }];
    NSArray *localNotificationsForDeletion = [localNotifications filteredArrayUsingPredicate:idPredicate];
    for (UILocalNotification *forDeletion in localNotificationsForDeletion) {
        [[UIApplication sharedApplication] cancelLocalNotification:forDeletion];
    }
}

@end
