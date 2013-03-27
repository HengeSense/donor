//
//  HSCalendarEventNotifier.m
//  Donor
//
//  Created by Sergey Seroshtan on 11.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSCalendarEventNotifier.h"
#import "HSCalendar.h"
#import "HSNotification.h"

#pragma mark - Observing context constants
static NSString * const kHSCalendarEventNotifierObservingContext = @"kHSCalendarEventNotifierObservingContext";

#pragma mark - Private interface
@interface HSCalendarEventNotifier ()

@property (nonatomic, weak) HSCalendar *calendarModel;
@property (nonatomic, strong) NSMutableArray *notificationHandlers;
@property (nonatomic, strong) NSMutableArray *notificationHandlerBlocks;
@property (nonatomic, strong) NSMutableArray *notificationsQueue;

@end

@implementation HSCalendarEventNotifier

#pragma mark - Memory management
- (id)init {
    self = [super init];
    if (self) {
        self.calendarModel = [HSCalendar sharedInstance];
        self.notificationHandlers = [[NSMutableArray alloc] init];
        self.notificationHandlerBlocks = [[NSMutableArray alloc] init];
        self.notificationsQueue = [[NSMutableArray alloc] init];
        [self registerCalendarModelObservation];
    }
    return self;
}

- (void)dealloc {
    [self unregisterCalendarModelObservation];
    self.notificationHandlers = nil;
    self.notificationHandlerBlocks = nil;
    self.notificationsQueue = nil;
}

#pragma mark - Notification events management
- (void)addNotificationHandler:(id<HSCalendarEventNotificationHandler>)notificationHandler {
    THROW_IF_ARGUMENT_NIL(notificationHandler);
    if (![self.notificationHandlers containsObject:notificationHandler]) {
        [self.notificationHandlers addObject:notificationHandler];
    }
}

- (void)removeNotificationHandler:(id<HSCalendarEventNotificationHandler>)notificationHandler {
    THROW_IF_ARGUMENT_NIL(notificationHandler);
    if ([self.notificationHandlers containsObject:notificationHandler]) {
        [self.notificationHandlers removeObject:notificationHandler];
    }
}

- (void)addNotificationHandlerBlock:(HSCalendarEventNotificationHandlerBlock)notificationHandlerBlock {
    THROW_IF_ARGUMENT_NIL(notificationHandlerBlock);
    if (![self.notificationHandlerBlocks containsObject:notificationHandlerBlock]) {
        [self.notificationHandlerBlocks addObject:[notificationHandlerBlock copy]];
    }
}

- (void)removeNotificationHandlerBlock:(HSCalendarEventNotificationHandlerBlock)notificationHandlerBlock {
    THROW_IF_ARGUMENT_NIL(notificationHandlerBlock);
    if ([self.notificationHandlerBlocks containsObject:notificationHandlerBlock]) {
        [self.notificationHandlerBlocks removeObject:notificationHandlerBlock];
    }
}

#pragma mark - Notification events processing
- (void)processLocalNotification:(UILocalNotification *)localNotification {
    THROW_IF_ARGUMENT_NIL(localNotification);
    @synchronized (self) {
        if ([self.calendarModel isModelUnlockedState]) {
            [self handleLocalNotification:localNotification];
        } else {
            [self.notificationsQueue addObject:localNotification];
        }
    }
}

#pragma mark - Notification events processing private
- (void)processNotificationsQueue {
    @synchronized (self) {
        NSMutableArray *processedLocalNotifications =
                [[NSMutableArray alloc] initWithCapacity:[self.notificationsQueue count]];
        for (UILocalNotification *localNotification in self.notificationsQueue) {
            if ([self.calendarModel isModelUnlockedState]) {
                [self handleLocalNotification:localNotification];
                [processedLocalNotifications addObject:localNotification];
            } else {
                // Calendar model was locked so handling process should be delayed.
                break;
            }
        }
        [self.notificationsQueue removeObjectsInArray:processedLocalNotifications];
    }
}

- (void)handleLocalNotification:(UILocalNotification *)localNotification {
    NSArray *allEvents = [self.calendarModel allEvents];
    NSArray *notificationEvents = [allEvents filteredArrayUsingPredicate:
            [NSPredicate predicateWithFormat: @"SELF isKindOfClass: %@", [HSNotificationEvent class]]];

    for (HSNotificationEvent *notificationEvent in notificationEvents) {
        if ([notificationEvent isSelfLocalNotification:localNotification]) {
            if ([notificationEvent isReminderLocalNotification:localNotification]) {
                [self fireCalendarNotificationWithEvent:notificationEvent nature:HSNotificationNatureType_Reminder
                                                 source:HSNotificationSourceType_Local];
            } else if ([notificationEvent isConfirmationLocalNotification:localNotification]) {
                [self fireCalendarNotificationWithEvent:notificationEvent nature:HSNotificationNatureType_Confirmation
                                                 source:HSNotificationSourceType_Local];
            } else {
                NSLog(@"Undefined local notification nature type, will be ignored");
            }
            break;
        }
    }
}

- (void)fireCalendarNotificationWithEvent:(HSNotificationEvent *)notificationEvent
        nature:(HSNotificationNatureType)nature source:(HSNotificationSourceType)source {
    HSNotification *notification = [HSNotification notificationWithEvent:notificationEvent
            nature:nature source:source];
    for (id<HSCalendarEventNotificationHandler> handler in self.notificationHandlers) {
        [handler handleNotification:notification];
    }
    for (HSCalendarEventNotificationHandlerBlock handlerBlock in self.notificationHandlerBlocks) {
        handlerBlock(notification);
    }
}

#pragma mark - Key-value observing
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change
        context:(void *)context {
    if ([keyPath isEqualToString:kHSCalendarModelStateChangedKeyPath] &&
            context == &kHSCalendarEventNotifierObservingContext) {
        if ([self.calendarModel isModelUnlockedState]) {
            [self processNotificationsQueue];
        }
    }
}

#pragma mark - Key-value observation utility
- (void)registerCalendarModelObservation {
    [self.calendarModel addObserver:self forKeyPath:kHSCalendarModelStateChangedKeyPath options:NSKeyValueObservingOptionNew
                            context:(void *)&kHSCalendarEventNotifierObservingContext];
}

- (void)unregisterCalendarModelObservation {
    [self.calendarModel removeObserver:self forKeyPath:kHSCalendarModelStateChangedKeyPath
                               context:(void *)&kHSCalendarEventNotifierObservingContext];
}

@end
