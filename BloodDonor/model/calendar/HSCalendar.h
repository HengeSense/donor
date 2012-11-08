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

/**
 * This class provides core application functionality - planing and managing events.
 */
@interface HSCalendar : NSObject

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

/**
 * Returns done blood donation event total number.
 */
- (NSUInteger)numberOfDoneBloodDonationEvents;

@end