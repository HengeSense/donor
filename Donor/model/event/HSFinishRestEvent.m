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

- (void)scheduleRemindLocalNotification {
    NSString *bloodDonationTypeString = [bloodDonationTypeToString(self.bloodDonationType) lowercaseString];
    [super scheduleLocalNotificationAtDate:[self.scheduledDate dateMovedToHour:12 minute:0]
                                 withAlertAction:kNotificationEventAlertActionDefault
                                   alertBody:[NSString stringWithFormat:@"Можно сдать %@.", bloodDonationTypeString]];
}

@end
