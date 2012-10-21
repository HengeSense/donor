//
//  HSCalendar.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 18.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSCalendar.h"

#pragma mark - Private interface declaration
@interface HSCalendar ()

/**
 * Calendar events. Objects of HSEvent class and it's subclasses.
 */
@property (nonatomic, strong) NSMutableSet *events;

/**
 * Calendar events observers.
 */
@property (nonatomic, strong) NSMutableSet *eventObservers;

/**
 * Notifies all calendar events observers with message eventWasAdded:.
 */
- (void) fireNotificationEventWasAdded: (HSEvent *) event;

/**
 * Notifies all calendar events observers with message eventWasAdded:.
 */
- (void) fireNotificationEventWasRemoved: (HSEvent *) event;
@end

@implementation HSCalendar

#pragma mark - Initialization

- (id) init {
    if (self = [super init]) {
        self.events = [[NSMutableSet alloc] init];
        self.eventObservers = [[NSMutableSet alloc] init];
    }
    return self;
}

#pragma mark - Calendar events observers methods

- (void) addEventObserver: (id<HSCalendarEventObserver>)eventObserver {
    THROW_IF_ARGUMENT_NIL(eventObserver, @"eventObserver is not specified");
    if (![self.eventObservers containsObject: eventObserver]) {
        [self.eventObservers addObject: eventObserver];
    }
}

- (void) removeEventObserver: (id<HSCalendarEventObserver>)eventObserver {
    THROW_IF_ARGUMENT_NIL(eventObserver, @"eventObserver is not specified");
    if ([self.eventObservers containsObject: eventObserver]) {
        [self.eventObservers removeObject: eventObserver];
    }
}

#pragma mark - Event manipulation methods

- (void) addEvent: (HSEvent *)event {
    THROW_IF_ARGUMENT_NIL(event, @"event is not specified");
    if (![self.events containsObject: event]) {
        [self.events addObject: event];
        [self fireNotificationEventWasAdded: event];
    }
}

- (void) removeEvent: (HSEvent *)event {
    THROW_IF_ARGUMENT_NIL(event, @"event is not specified");
    if ([self.events containsObject: event]) {
        [self.events removeObject: event];
        [self fireNotificationEventWasRemoved: event];
    }
}

- (NSSet *) allEvents {
    return [NSSet setWithSet: self.events];
}

#pragma mark - Methods to interact with cloud data service - parse.com
- (void) syncWithServer: (CompletionBlockType)completion {
    
}

#pragma mark - Private section implementation
- (void) fireNotificationEventWasAdded: (HSEvent *) event {
    for (id<HSCalendarEventObserver> observer in self.eventObservers) {
        if ([observer respondsToSelector: @selector(eventWasAdded:)]) {
            [observer eventWasAdded: event];
        }
    }
}

- (void) fireNotificationEventWasRemoved: (HSEvent *) event {
    for (id<HSCalendarEventObserver> observer in self.eventObservers) {
        if ([observer respondsToSelector: @selector(eventWasAdded:)]) {
            [observer eventWasAdded: event];
        }
    }
}
@end
