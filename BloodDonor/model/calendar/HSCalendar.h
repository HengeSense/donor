//
//  HSCalendar.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 18.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HSModelCommon.h"
#import "HSEvent.h"
#import "HSBloodRemoteEvent.h"

/// @name HSCalendar protocol declaration

@protocol HSCalendarEventObserver <NSObject>
@optional
/**
 * Emmits when new event was added to the calendar.
 */
- (void)eventWasAdded: (HSEvent *)event;

/**
 * Emmits when event was removed from the calendar.
 */
- (void)eventWasRemoved: (HSEvent *)event;

/**
 * Emmits when event was updated in the calendar.
 */
- (void)eventWasUpdated: (HSEvent *)event;

/**
 * Emmits when events in the calendar was changed in some reason: pulled from server etc.
 */
- (void)eventsWasUpdated: (NSArray *)events;

@end

/**
 * This class provides core application functionality - planing and managing events.
 */
@interface HSCalendar : NSObject

/// @name Calendar events observers methods.

/**
 * Adds calendar event observer.
 */
- (void)addEventObserver: (id<HSCalendarEventObserver>)eventObserver;

/**
 * Removes calendar event observer
 */
- (void)removeEventObserver: (id<HSCalendarEventObserver>)eventObserver;

/// @name Methods to interact with cloud data service - parse.com

/**
 * Pushes new events to the server.
 */
- (void)pushEventsToServer: (CompletionBlockType)completion;

/**
 * Pulls all remote events from the server.
 * Notifies observers with [HSCalendarEventObserver calendarWasUpdatedWithEvents] method.
 */
- (void)pullEventsFromServer: (CompletionBlockType)completion;

/// @name Event manipulation methods

/**
 * Adds specified event to the calendar.
 * If specified event exist, this operation will no effect.
 * Notifies observers with [HSCalendarEventObserver eventWasAdded:] methods.
 */
- (void)addEvent: (HSEvent *)event;

/**
 * Removes specified event from the calendar.
 * If specified event does not exist, this operation will no effect.
 * Notifies observers with [HSCalendarEventObserver eventWasRemoved:] methods.
 */
- (void)removeEvent: (HSEvent *)event;

/**
 * Updates specified event in the calendar.
 * If specified event does not exist, this operation will no effect.
 * Notifies observers with [HSCalendarEventObserver eventWasUpdated:] methods.
 */
- (void)updateEvent: (HSEvent *)event;

/// @name Remote blood events manipulation methods

/**
 * Adds blood remote event.
 * @param remoteBloodEvent - remote planning blood event
 * @param completion - completion block of code
 */
- (void) addBloodRemoteEvent: (HSBloodRemoteEvent *)bloodRemoteEvent completion: (CompletionBlockType)completion;

/**
 * Removes blood remote event.
 * @param remoteBloodEvent - remote planning blood event
 * @param completion - completion block of code
 */
- (void) removeBloodRemoteEvent: (HSBloodRemoteEvent *)bloodRemoteEvent completion: (CompletionBlockType)completion;

/**
 * Returns all events in the calendar.
 */
- (NSArray *)allEvents;

/**
 * Returns all events for the specified day.
 */
- (NSArray *)eventsForDay: (NSDate *)dayDate;

@end
