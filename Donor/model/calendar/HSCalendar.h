//
//  HSCalendar.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 18.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#import "HSModelCommon.h"
#import "HSEvent.h"
#import "HSBloodRemoteEvent.h"
#import "HSCalendarInfo.h"

/// @name Key-Value observing constants

/**
 * Key path for observing calendar state (locked model / unlocked model).
 */
extern NSString * const kHSCalendarModelStateChangedKeyPath;

/// @name HSCalendar protocol declaration
/**
 * This class provides core application functionality - planing and managing events.
 */
@interface HSCalendar : NSObject<HSCalendarInfo>

/// @name Singleton
+ (HSCalendar *)sharedInstance;

/// @name Methods to interact with cloud data service - parse.com
/**
 * Unlocks calendar model with specified user. After unlocking client can interact with user's calendar events.
 */
- (void)unlockModelWithUser:(PFUser *)user;

/**
 * Locks calendar model. After locking calenadr model is unavailable.
 * If client tries to interaction calls trigger exception.
 */
- (void)lockModel;

/**
 * Define wheter calendar model is in locked state or not.
 *     See [self unlockModelWithUser:] and [self lockModel] methods.
 */
- (BOOL)isModelLockedState;

/**
 * Define wheter calendar model is in unlocked state or not.
 *     See [self unlockModelWithUser:] and [self lockModel] methods.
 */
- (BOOL)isModelUnlockedState;

/**
 * Pulls all remote events from the server.
 * Notifies observers with [HSCalendarEventObserver calendarWasUpdatedWithEvents] method.
 */
- (void)pullEventsFromServer: (CompletionBlockType)completion;

/// @name Remote blood events manipulation methods

/**
 * Adds blood remote event. Server synchronized.
 * @param remoteBloodEvent - remote planning blood event
 * @param completion - completion block of code
 */
- (void) addBloodRemoteEvent: (HSBloodRemoteEvent *)bloodRemoteEvent completion: (CompletionBlockType)completion;

/**
 * Removes blood remote event. Server synchronized.
 * @param remoteBloodEvent - remote planning blood event
 * @param completion - completion block of code
 */
- (void) removeBloodRemoteEvent: (HSBloodRemoteEvent *)bloodRemoteEvent completion: (CompletionBlockType)completion;

/**
 * Replace blood remote event. Server synchronized.
 * @param remoteBloodEvent - remote planning blood event
 * @param completion - completion block of code
 */
- (void) replaceBloodRemoteEvent: (HSBloodRemoteEvent *)oldEvent withEvent:(HSBloodRemoteEvent *)newEvent
                      completion: (CompletionBlockType)completion;

/**
 * Returns all events in the calendar.
 */
- (NSArray *)allEvents;

/**
 * Returns all events for the specified day.
 */
- (NSArray *)eventsForDay: (NSDate *)dayDate;

@end
