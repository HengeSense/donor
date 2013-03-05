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
- (NSString *)alertBodyForReminderLocalNotification {
    return @"Завтра у Вас запланирован анализ.";
}

- (NSString *)alertBodyForConfirmationLocalNotification {
    return @"Вы сегодня здавали анализ?";
}

@end
