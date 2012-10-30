//
//  HSCalendar.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 18.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSCalendar.h"

#import <Parse/Parse.h>

#import "HSModelCommon.h"
#import "HSCalendarException.h"

#import "HSEvent.h"
#import "HSBloodRemoteEvent.h"

#pragma mark - Remote Users object's field keys
static NSString * const kUserEventsRelation = @"events";

#pragma mark - Remote Events object's field keys
static NSString * const kEventDate = @"date";

#pragma mark - Private interface declaration
@interface HSCalendar ()

/**
 * Calendar events. Objects of HSEvent class and it's subclasses.
 */
@property (nonatomic, strong) NSMutableArray *events;

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

/**
 * Notifies all calendar events observers with message eventWasUpdated:.
 */
- (void) fireNotificationEventWasUpdated: (HSEvent *) event;

/**
 * Makes period calculations ans adds depended events to the calendar;
 */
- (void)addCalculatedEvents;
@end

@implementation HSCalendar

#pragma mark - Initialization

- (id) init {
    if (self = [super init]) {
        self.events = [[NSMutableArray alloc] init];
        self.eventObservers = [[NSMutableSet alloc] init];
    }
    return self;
}

#pragma mark - Calendar events observers methods

- (void)addEventObserver: (id<HSCalendarEventObserver>)eventObserver {
    THROW_IF_ARGUMENT_NIL(eventObserver, @"eventObserver is not specified");
    if (![self.eventObservers containsObject: eventObserver]) {
        [self.eventObservers addObject: eventObserver];
    }
}

- (void)removeEventObserver: (id<HSCalendarEventObserver>)eventObserver {
    THROW_IF_ARGUMENT_NIL(eventObserver, @"eventObserver is not specified");
    if ([self.eventObservers containsObject: eventObserver]) {
        [self.eventObservers removeObject: eventObserver];
    }
}

#pragma mark - Event manipulation methods

- (void)addEvent: (HSEvent *)event {
    THROW_IF_ARGUMENT_NIL(event, @"event is not specified");
    
    if (![self.events containsObject: event]) {
        [self.events addObject: event];
        [self fireNotificationEventWasAdded: event];
    }
}

- (void)removeEvent: (HSEvent *)event {
    THROW_IF_ARGUMENT_NIL(event, @"event is not specified");
    if ([self.events containsObject: event]) {
        [self.events removeObject: event];
        [self fireNotificationEventWasRemoved: event];
    }
}

- (void)updateEvent: (HSEvent *)event {
    THROW_IF_ARGUMENT_NIL(event, @"event is not specified")
    // remove event
    if ([self.events containsObject: event]) {
    
    }
    
    [self.events addObject: event];
    [self addCalculatedEvents];
    
}

- (NSSet *)allEvents {
    return [NSSet setWithArray: self.events];
}

- (NSSet *)eventsForDay: (NSDate *)dayDate {
    THROW_IF_ARGUMENT_NIL(dayDate, @"dayDate is not specified");
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *dayDateComponents =
            [currentCalendar components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                               fromDate: dayDate];
    NSDate *roundedDayDate = [currentCalendar dateFromComponents: dayDateComponents];
    
    NSSet *allEvents = [self allEvents];
    NSPredicate *eventsBetweenDates =
    [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        HSEvent *testedEvent = (HSEvent *)evaluatedObject;
        NSDateComponents *testedEventDayDateComponents =
                [currentCalendar components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                   fromDate: testedEvent.scheduledDate];
        NSDate *roundedTestedEventDate = [currentCalendar dateFromComponents: testedEventDayDateComponents];
        if (roundedDayDate.timeIntervalSince1970 == roundedTestedEventDate.timeIntervalSince1970) {
            return YES;
        } else {
            return NO;
        }
    }];
    NSSet *resultEvents = [allEvents filteredSetUsingPredicate: eventsBetweenDates];
    return resultEvents;
}

#pragma mark - Methods to interact with cloud data service - parse.com
- (void)pullEventsFromServer: (CompletionBlockType)completion {
    THROW_IF_ARGUMENT_NIL(completion, @"completion block is not specified")
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser != nil) {
        PFRelation *eventsRelation = [currentUser relationforKey: kUserEventsRelation];
        PFQuery *eventsQuery = [eventsRelation query];
        [eventsQuery orderByDescending: kEventDate];
        
        [eventsQuery findObjectsInBackgroundWithBlock: ^(NSArray *remoteEvents, NSError *error) {
            [self.events removeAllObjects];
            for (PFObject *remoteEvent in remoteEvents) {
                [self.events addObject: [HSBloodRemoteEvent buildBloodEventWithRemoteEvent: remoteEvent]];
            }
            [self addCalculatedEvents];
            [self fireNotificationEventsWasUpdated: self.events];
            BOOL success = error == nil ? YES : NO;
            completion(success, error);
        }];
    } else {
        @throw [HSCalendarException exceptionWithName: HSCalendarExceptionUserUnauthorized
                reason: @"User is not authorized yet. Calendar can't be used." userInfo: nil];
    }
}

- (void)pushEventsToServer: (CompletionBlockType)completion {
    NSArray *remoteBloodEvents = [self.events filteredArrayUsingPredicate:
            [NSPredicate predicateWithFormat: @"class isKindOfClass: %@", [HSBloodRemoteEvent class]]];
    
    __block size_t unsavedRemoteObjectsCount = remoteBloodEvents.count;
    __block BOOL allEventsWasSavedOrError = NO;
    CompletionBlockType partialCompletion = ^(BOOL succeed, NSError *error) {
        if (!allEventsWasSavedOrError) {
            if (succeed) {
                --unsavedRemoteObjectsCount;
                allEventsWasSavedOrError = unsavedRemoteObjectsCount > 0 ? NO : YES;
            } else {
                allEventsWasSavedOrError = YES;
            }
            if (allEventsWasSavedOrError) {
                completion(succeed, error);
            }
        }
    };
    for (HSBloodRemoteEvent *remoteBloodEvent in remoteBloodEvents) {
        [remoteBloodEvent saveWithCompletionBlock: partialCompletion];
    }
}

#pragma mark - Private section implementation
- (void)fireNotificationEventWasAdded: (HSEvent *) event {
    for (id<HSCalendarEventObserver> observer in self.eventObservers) {
        if ([observer respondsToSelector: @selector(eventWasAdded:)]) {
            [observer eventWasAdded: event];
        }
    }
}

- (void)fireNotificationEventWasRemoved: (HSEvent *) event {
    for (id<HSCalendarEventObserver> observer in self.eventObservers) {
        if ([observer respondsToSelector: @selector(eventWasAdded:)]) {
            [observer eventWasAdded: event];
        }
    }
}

- (void)fireNotificationEventsWasUpdated: (NSArray *) events {
    for (id<HSCalendarEventObserver> observer in self.eventObservers) {
        if ([observer respondsToSelector: @selector(eventsWasUpdated:)]) {
            [observer eventsWasUpdated: events];
        }
    }
}

- (void) fireNotificationEventWasUpdated: (HSEvent *)event {
    for (id<HSCalendarEventObserver> observer in self.eventObservers) {
        if ([observer respondsToSelector: @selector(eventWasUpdated:)]) {
            [observer eventWasUpdated: event];
        }
    }
}

-(void)addCalculatedEvents {
#warning Unimplemented
}
@end
