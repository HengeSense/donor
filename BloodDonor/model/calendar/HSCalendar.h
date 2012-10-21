//
//  HSCalendar.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 18.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HSEvent.h"

/// @name HSCalendar types declaration

/**
 * Completion block of code. Invoked after asynch operation completion.
 */
typedef void(^CompletionBlockType)(BOOL success, NSError *error);

/// @name HSCalendar protocol declaration

@protocol HSCalendarEventObserver <NSObject>
@optional
/**
 * Emmits when new event was added to the calendar.
 */
- (void) eventWasAdded: (HSEvent *) event;

/**
 * Emmits when event was removed from the calendar.
 */
- (void) eventWasRemoved: (HSEvent *) event;

/**
 * Emmits when events in the calendar was changed in some reason: updates from server was received, etc.
 */
- (void) calendarWasUpdatedWithEvents: (NSArray *) events;

@end

/**
 * This class provides core application functionality - planing and managing events.
 */
@interface HSCalendar : NSObject

/// @name Calendar events observers methods.

/**
 * Adds calendar event observer.
 */
- (void) addEventObserver: (id<HSCalendarEventObserver>) eventObserver;

/**
 * Removes calendar event observer
 */
- (void) removeEventObserver: (id<HSCalendarEventObserver>) eventObserver;

/// @name Methods to interact with cloud data service - parse.com

/**
 * Synchronize local events with remote server events.
 * Invokes [HSCalendarEventObserver calendarWasUpdatedWithEvents] observer method.
 */
- (void) syncWithServer: (CompletionBlockType) completion;

/// @name Event manipulation methods

/**
 * Adds specified event to the calendar.
 * Invokes [HSCalendarEventObserver eventWasAdded:] observer methods.
 * @throw HSCalendarException if specified event could not be added.
 */
- (void) addEvent: (HSEvent *) event;

/**
 * Removes specified event from the calendar.
 * Invokes [HSCalendarEventObserver eventWasRemoved:] observer methods.
 * @throw HSCalendarException if specified event does not exist.
 */
- (void) removeEvent: (HSEvent *) event;

/**
 * Returns all events in the calendar.
 */
- (NSSet *) allEvents;

@end
