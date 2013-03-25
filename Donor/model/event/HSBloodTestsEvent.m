//
//  HSTestDonationEvent.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 22.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSBloodTestsEvent.h"
#import "HSBloodRemoteEvent+LocalNotification_Protected.h"

@implementation HSBloodTestsEvent

#pragma mark - Protected interface implementation
- (NSString *)alertBodyForReminderLocalNotificationWithMinutesLeft:(NSUInteger)minutesLeft {
    if (minutesLeft < 60) {
        return [NSString stringWithFormat:@"Через %u мин. у Вас запланирован анализ.", minutesLeft];
    } else {
        return [NSString stringWithFormat:@"Через %u ч. %u мин. у Вас запланирован анализ.",
                (NSUInteger)(minutesLeft / 60), minutesLeft % 60];
    }
}

- (NSString *)alertBodyForConfirmationLocalNotification {
    return @"Вы сегодня здавали анализ?";
}

@end
