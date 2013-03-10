//
//  HSNotificationEvent.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 18.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSNotificationEvent.h"
#import "NSDate+HSCalendar.h"

NSString * const kNotificationEventAlertActionDefault = @"Open";

NSString * const kLocalNotificationUserInfoKey_ClassName = @"eventClassName";
NSString * const kLocalNotificationUserInfoKey_ScheduleDate = @"eventScheduleDate";
static NSString * const kLocalNotificationUserInfoKey_UID = @"eventUID";
static NSString * const kLocalNotificationUserInfoKey_IsReminder = @"isReminder";
static NSString * const kLocalNotificationUserInfoKey_IsConfirmation = @"isConfirmation";

#pragma mark - KVC constatnts
static NSString * const kObservingKey_ScheduleDate = @"scheduleDate";

@implementation HSNotificationEvent

@synthesize reminderFireDate = _reminderFireDate;

#pragma mark - Initialization/Deallocation
- (id)init {
    if (self = [super init]) {
        [self addObserver:self forKeyPath:kObservingKey_ScheduleDate options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:kObservingKey_ScheduleDate];
}

#pragma mark - Getters/Setters
- (NSDate *)reminderFireDate {
    if (_reminderFireDate == nil) {
        self.reminderFireDate = [self defineReminderFireDate];
    }
    return _reminderFireDate;
}


#pragma mark - KVC Observing
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change
        context:(void *)context {
    if ([keyPath isEqualToString:kObservingKey_ScheduleDate]) {
        [self updateReminderFireDate];
    }
}

#pragma mark - Public API
- (NSString *)formattedReminderFireDate {
    return [self.dateFormatter stringFromDate: self.reminderFireDate];
}

- (void)scheduleLocalNotificationAtDate:(NSDate *)date withAlertAction:(NSString *)alertAction
        alertBody:(NSString *)alertBody userInfo:(NSDictionary *)userInfo {
    THROW_IF_ARGUMENT_NIL_2(date);

    if (date.timeIntervalSinceNow < 0) {
        return;
    }
        
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = date;
    notification.alertBody = alertBody;
    notification.alertAction = alertAction;
    notification.userInfo = userInfo;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    NSLog(@"Was add local notification for event class: %@, with userInfo:%@", NSStringFromClass(self.class), userInfo);
}

+ (void)cancelAllLocalNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

#pragma mark - Protected helpers
- (BOOL)isSelfLocalNotification:(UILocalNotification *)localNotification {
    THROW_IF_ARGUMENT_NIL_2(localNotification);
    NSString *className = [localNotification.userInfo objectForKey:kLocalNotificationUserInfoKey_ClassName];
    NSNumber *uid = [localNotification.userInfo objectForKey:kLocalNotificationUserInfoKey_UID];
    return [className isEqualToString:NSStringFromClass(self.class)] && [self uid] == uid.unsignedIntegerValue;
}

- (NSDictionary *)localNotificationBaseUserInfo {
    return @{kLocalNotificationUserInfoKey_ClassName : NSStringFromClass(self.class),
             kLocalNotificationUserInfoKey_UID : [NSNumber numberWithUnsignedInteger:[self uid]],
             kLocalNotificationUserInfoKey_ScheduleDate : self.scheduleDate};
}

- (NSDictionary *)reminderLocalNotificationBaseUserInfo {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result addEntriesFromDictionary:[self localNotificationBaseUserInfo]];
    [result addEntriesFromDictionary: @{kLocalNotificationUserInfoKey_IsReminder : [NSNumber numberWithBool:YES]}];
    return result;
}

- (NSDictionary *)confirmationLocalNotificationBaseUserInfo {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result addEntriesFromDictionary:[self localNotificationBaseUserInfo]];
    [result addEntriesFromDictionary: @{kLocalNotificationUserInfoKey_IsConfirmation : [NSNumber numberWithBool:YES]}];
    return result;
}

- (BOOL)hasScheduledReminderLocalNotification {
    NSPredicate *checkPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        UILocalNotification *localNotification = evaluatedObject;
        NSNumber *isReminder = [localNotification.userInfo objectForKey:kLocalNotificationUserInfoKey_IsReminder];
        return [self isSelfLocalNotification:localNotification] &&
                (isReminder != nil ? isReminder.boolValue : NO);
    }];
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    return [[localNotifications filteredArrayUsingPredicate:checkPredicate] count] > 0;
}

- (BOOL)hasScheduledConfirmationLocalNotification {
    NSPredicate *checkPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        UILocalNotification *localNotification = evaluatedObject;
        NSNumber *isConfirmation =
                [localNotification.userInfo objectForKey:kLocalNotificationUserInfoKey_IsConfirmation];
        return [self isSelfLocalNotification:localNotification] &&
                (isConfirmation != nil ? isConfirmation.boolValue : NO);
    }];
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    return [[localNotifications filteredArrayUsingPredicate:checkPredicate] count] > 0;
}

- (void)cancelScheduledLocalNotification {
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSPredicate *idPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [self isSelfLocalNotification:evaluatedObject];
    }];
    NSArray *localNotificationsForDeletion = [localNotifications filteredArrayUsingPredicate:idPredicate];
    for (UILocalNotification *forDeletion in localNotificationsForDeletion) {
        [[UIApplication sharedApplication] cancelLocalNotification:forDeletion];
    }
}

- (void)updateReminderFireDate {
    if (self.reminderFireDate != nil) {
        self.reminderFireDate = [[self.scheduleDate dayBefore] dateMovedToHour:[self.reminderFireDate hour]
                                                                        minute:[self.reminderFireDate minute]];
    } else {
        self.reminderFireDate = [self reminderFireDateDefault];
    }
}

#pragma mark - Abstract methods
- (NSDate *)reminderFireDateDefault {
    THROW_UNIMPLEMENTED_EXCEPTION;
}

- (void)scheduleReminderLocalNotificationAtDate:(NSDate *)fireDate {
    THROW_UNIMPLEMENTED_EXCEPTION;
}

- (void)scheduleConfirmationLocalNotification {
    THROW_UNIMPLEMENTED_EXCEPTION;
}

#pragma mark - Private utility
- (NSDate *)defineReminderFireDate {
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *localNotification in localNotifications) {
        if ([self isSelfLocalNotification:localNotification]) {
            NSNumber *isReminder = [localNotification.userInfo objectForKey:kLocalNotificationUserInfoKey_IsReminder];
            if (isReminder != nil && isReminder.boolValue) {
                NSLog(@"Was defined fire date: %@", localNotification.fireDate);
                return localNotification.fireDate;
            }
        }
    }
    return nil;
}

#pragma mark - HSUIDProvider protocol implementation
- (NSUInteger)uid {
    return [super uid];
}

@end
