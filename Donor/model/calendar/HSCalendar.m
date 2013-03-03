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
#import "HSBloodDonationEvent.h"
#import "HSBloodTestsEvent.h"
#import "HSFinishRestEvent.h"

#import "NSDate+HSCalendar.h"

#pragma mark - Remote Users object's field keys
static NSString * const kUserEventsRelation = @"events";

#pragma mark - Remote Events object's field keys
static NSString * const kEventDate = @"date";

#pragma mark - Private interface declaration
@interface HSCalendar ()

/**
 * Calendar events. Objects of HSEvent class and it's subclasses.
 */
@property (nonatomic, strong) NSMutableArray *datePurposeModifierEvents;

/**
 * Array of HSFinishRestEvent objects.
 */
@property (nonatomic, strong) NSMutableArray *finishRestEvents;

/**
 * Array of HSBloodRemoteEvent objects.
 */
@property (nonatomic, strong) NSMutableArray *bloodRemoteEvents;

/**
 * Calendar events observers.
 */
@property (nonatomic, strong) NSMutableSet *eventObservers;

/**
 * Makes period calculations ans adds depended finish rest events to the calendar.
 */
- (void)addFinishRestEvents;

/**
 * Updates all finish rest events (removes old and adds new).
 */
- (void)updateFinishRestEvents;

/// @name Utility methods
/**
 * Check whether calendar can add specified blood remote event to the calendar or not.
 */
- (BOOL)canAddBloodRemoteEvent: (HSBloodRemoteEvent *)bloodRemoteEvent error: (NSError **)error;

/**
 * Notice that period not includes bounds (fromDate, toDate).
 */
- (void)removeUndoneBloodDonationEventsOfType:(HSBloodDonationType)bloodDonationType fromDate:(NSDate *)fromDate
                                       toDate:(NSDate *)toDate;

@end

@implementation HSCalendar

#pragma mark - Initialization

- (id) init {
    if (self = [super init]) {
        self.datePurposeModifierEvents = [[NSMutableArray alloc] init];
        self.finishRestEvents = [[NSMutableArray alloc] init];
        self.bloodRemoteEvents = [[NSMutableArray alloc] init];
        self.eventObservers = [[NSMutableSet alloc] init];
    }
    return self;
}

#pragma mark - Events accessors

- (NSArray *)allEvents {
    NSMutableArray *allArrays = [[NSMutableArray alloc] initWithArray: self.datePurposeModifierEvents];
    [allArrays addObjectsFromArray: self.finishRestEvents];
    [allArrays addObjectsFromArray: self.bloodRemoteEvents];
    return [NSArray arrayWithArray: allArrays];
}

- (NSArray *)eventsForDay: (NSDate *)dayDate {
    THROW_IF_ARGUMENT_NIL(dayDate, @"dayDate is not specified");
    NSArray *allEvents = [self allEvents];
    NSPredicate *eventsBetweenDates =
        [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            HSEvent *testedEvent = (HSEvent *)evaluatedObject;
            return [dayDate isTheSameDay: testedEvent.scheduleDate];
        }];
    NSArray *resultEvents = [allEvents filteredArrayUsingPredicate: eventsBetweenDates];
    return resultEvents;
}

#pragma mark - HSCalendarInfo protocaol implementation
- (NSUInteger)numberOfDoneBloodDonationEvents {
    return [[self doneBloodDonationEvents] count];
}

- (NSDate *)nextBloodDonationDate {
        NSArray *descendingUndoneBloodDonationEvents = [[self undoneBloodDonationEvents]
            sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        HSBloodDonationEvent *first = obj1;
        HSBloodDonationEvent *second = obj2;
        if (first.scheduleDate.timeIntervalSince1970 < second.scheduleDate.timeIntervalSince1970) {
            return NSOrderedDescending;
        } else if (first.scheduleDate.timeIntervalSince1970 > second.scheduleDate.timeIntervalSince1970) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    return [[descendingUndoneBloodDonationEvents lastObject] scheduleDate];
}

#pragma mark - Remote events manipulation methods
- (void)addBloodRemoteEvent: (HSBloodRemoteEvent *)bloodRemoteEvent completion: (CompletionBlockType)completion {
    THROW_IF_ARGUMENT_NIL(bloodRemoteEvent, @"bloodRemoteEvent is not specified");
    if ([self.bloodRemoteEvents containsObject:bloodRemoteEvent]) {
        [NSException raise:NSInvalidArgumentException format:@"Can't add already existing event in calendar"];
    }
    NSError *addError = nil;
    if([self canAddBloodRemoteEvent: bloodRemoteEvent error: &addError]) {
        [bloodRemoteEvent saveWithCompletionBlock:^(BOOL success, NSError *error) {
            if (success) {
                if (![self.bloodRemoteEvents containsObject: bloodRemoteEvent]) {
                    [bloodRemoteEvent scheduleReminderLocalNotificationAtDate:nil];
                    [bloodRemoteEvent scheduleConfirmationLocalNotificationAtDate:nil];
                    [self.bloodRemoteEvents addObject: bloodRemoteEvent];
                }
            }
            if (completion != nil) {
                NSError *customError = nil;
                if (error) {
                    NSDictionary *userInfo = @{
                        NSUnderlyingErrorKey : error
                    };
                    customError = [NSError errorWithDomain: HSRemoteServerResponseErrorDomain code: 0
                                                  userInfo: userInfo];
                }
                completion(success, customError);
            }
        }];
    } else {
        completion(NO, addError);
    }
}

- (void)removeBloodRemoteEvent:(HSBloodRemoteEvent *)bloodRemoteEvent completion:(CompletionBlockType)completion {
    THROW_IF_ARGUMENT_NIL(bloodRemoteEvent, @"bloodRemoteEvent is not specified");
    if (![self.bloodRemoteEvents containsObject:bloodRemoteEvent]) {
        [NSException raise:NSInvalidArgumentException format:@"Can't remove not existing event in calendar"];
    }
    [bloodRemoteEvent removeWithCompletionBlock:^(BOOL success, NSError *error) {
        if (success) {
            [bloodRemoteEvent cancelScheduledLocalNotification];
            [self.bloodRemoteEvents removeObject: bloodRemoteEvent];
            if (completion != nil) {
                completion(success, error);
            }
        } else {
            NSError *localError = [NSError errorWithDomain: HSRemoteServerResponseErrorDomain code: 0 userInfo: nil];
            if (completion != nil) {
                completion(NO, localError);
            }
        }
    }];
}

- (void)replaceBloodRemoteEvent:(HSBloodRemoteEvent *)oldEvent withEvent:(HSBloodRemoteEvent *)newEvent
                     completion:(CompletionBlockType)completion {
    THROW_IF_ARGUMENT_NIL(oldEvent, @"oldEvent is not specified");
    THROW_IF_ARGUMENT_NIL(newEvent, @"newEvent is not specified");
    if (![self.bloodRemoteEvents containsObject:oldEvent]) {
        [NSException raise:NSInvalidArgumentException format:@"Can't replace not existing event in calendar"];
    }
    if ([self.bloodRemoteEvents containsObject:newEvent]) {
        [NSException raise:NSInvalidArgumentException format:@"Can't replace with existing event in calendar"];
    }
    
    [self.bloodRemoteEvents removeObject:oldEvent];
    [self updateFinishRestEvents];
    NSError *replaceError = nil;
    if ([self canAddBloodRemoteEvent:newEvent error:&replaceError]) {
        [oldEvent removeWithCompletionBlock:^(BOOL success, NSError *error) {
            if (success) {
                [oldEvent cancelScheduledLocalNotification];
                [newEvent saveWithCompletionBlock:^(BOOL success, NSError *error) {
                    if (success) {
                        [newEvent scheduleReminderLocalNotificationAtDate:nil];
                        [newEvent scheduleConfirmationLocalNotificationAtDate:nil];
                        [self.bloodRemoteEvents addObject: newEvent];
                        [self updateFinishRestEvents];
                    } else {
                        NSLog(@"Replace failed in the middle if transaction: old event was removed,"
                              " but adding new one was fifnished with error: %@", error);
                    }
                    if (completion != nil) {
                        NSError *customError = nil;
                        if (error) {
                            NSDictionary *userInfo = @{
                                NSUnderlyingErrorKey : error
                            };
                            customError = [NSError errorWithDomain: HSRemoteServerResponseErrorDomain code: 0
                                                          userInfo: userInfo];
                        }
                        completion(success, customError);
                    }
                }];
            } else {
                [self.bloodRemoteEvents addObject:oldEvent];
                [self updateFinishRestEvents];
                if (completion != nil) {
                    NSError *customError = nil;
                    if (error) {
                        NSDictionary *userInfo = @{
                        NSUnderlyingErrorKey : error
                        };
                        customError = [NSError errorWithDomain: HSRemoteServerResponseErrorDomain code: 0
                                                      userInfo: userInfo];
                    }
                    completion(success, customError);
                }
            }
        }];
    } else {
        [self.bloodRemoteEvents addObject:oldEvent];
        [self updateFinishRestEvents];
        if (completion != nil) {
            completion(NO, replaceError);
        }
    }
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
            [self.bloodRemoteEvents removeAllObjects];
            for (PFObject *remoteEvent in remoteEvents) {
                [self.bloodRemoteEvents addObject: [HSBloodRemoteEvent buildBloodEventWithRemoteEvent: remoteEvent]];
            }
            [self updateFinishRestEvents];
            BOOL success = error == nil ? YES : NO;
            completion(success, error);
        }];
    } else {
        @throw [HSCalendarException exceptionWithName: HSCalendarExceptionUserUnauthorized
                reason: @"User is not authorized yet. Calendar can't be used." userInfo: nil];
    }
}

-(void)addFinishRestEvents {    
    NSArray *orderedDoneBloodDonationEvents = [[self doneBloodDonationEvents]
            sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        HSBloodDonationEvent *first = obj1;
        HSBloodDonationEvent *second = obj2;
        if (first.scheduleDate.timeIntervalSince1970 < second.scheduleDate.timeIntervalSince1970) {
            return NSOrderedAscending;
        } else if (first.scheduleDate.timeIntervalSince1970 > second.scheduleDate.timeIntervalSince1970) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    if (orderedDoneBloodDonationEvents.count > 0) {
        HSBloodDonationEvent *lastDoneBloodDonationEvent = [orderedDoneBloodDonationEvents lastObject];
        NSArray *finishRestEvents = [lastDoneBloodDonationEvent getFinishRestEvents];

        for (HSFinishRestEvent *finishRestEvent in finishRestEvents) {
            [self removeUndoneBloodDonationEventsOfType:finishRestEvent.bloodDonationType
                                               fromDate:lastDoneBloodDonationEvent.scheduleDate
                                                 toDate:finishRestEvent.scheduleDate];
        }
        
        for (HSFinishRestEvent *finishRestEvent in finishRestEvents) {
            [finishRestEvent scheduleReminderLocalNotificationAtDate:nil];
        }
        [self.finishRestEvents addObjectsFromArray: finishRestEvents];
    }
}

- (void)updateFinishRestEvents {
    for (HSNotificationEvent *finishRestEvent in self.finishRestEvents) {
        [finishRestEvent cancelScheduledLocalNotification];
    }
    [self.finishRestEvents removeAllObjects];
    [self addFinishRestEvents];
}

#pragma mark - Utility methods 
- (BOOL)canAddBloodRemoteEvent: (HSBloodRemoteEvent *)bloodRemoteEvent error: (NSError **)error {
    THROW_IF_ARGUMENT_NIL(bloodRemoteEvent, @"bloodRemoteEvent is not specified");    
    NSArray *eventsInTheSameDay = [self eventsForDay: bloodRemoteEvent.scheduleDate];
    NSArray *remoteEventsInTheSameDay = [eventsInTheSameDay filteredArrayUsingPredicate:
            [NSPredicate predicateWithFormat: @"SELF isKindOfClass: %@", [HSBloodRemoteEvent class]]];
    BOOL isFreeDay = remoteEventsInTheSameDay.count == 0;
    if (isFreeDay) {
        if ([bloodRemoteEvent isKindOfClass: [HSBloodTestsEvent class]]) {
            return YES;
        } else {
            HSBloodDonationEvent *bloodDonationEvent = (HSBloodDonationEvent *)bloodRemoteEvent;
            if ([self isAfterLastDoneBloodDonationEvent: bloodDonationEvent] &&
                [self isBloodDonationEventAfterRestPeriod: bloodDonationEvent]) {
                return YES;
            } else {
                if (error != NULL) {
                    *error = [[NSError alloc] initWithDomain: HSCalendarAddEventErrorDomain
                            code: HSCalendarAddEventErrorDomainCode_RestPeriodNotFinished userInfo: nil];
                }
                return NO;
            }
        }
    } else {
        // Day is busy with other blood remote event.
        if (error != NULL) {
            *error = [[NSError alloc] initWithDomain: HSCalendarAddEventErrorDomain
                    code: HSCalendarAddEventErrorDomainCode_DayIsBusy userInfo: nil];
        }
        return NO;
    }
}

- (NSArray *)bloodDonationEvents {
    return [self.bloodRemoteEvents filteredArrayUsingPredicate:
            [NSPredicate predicateWithFormat: @"SELF isKindOfClass: %@", [HSBloodDonationEvent class]]];
}

- (NSArray *)doneBloodDonationEvents {
    NSPredicate *doneBloodDonationEventsPredicate =
        [NSPredicate predicateWithFormat: @"(SELF isKindOfClass: %@) AND (isDone == YES)",
        [HSBloodDonationEvent class]];
    return [self.bloodRemoteEvents filteredArrayUsingPredicate: doneBloodDonationEventsPredicate];
}

- (NSArray *)undoneBloodDonationEvents {
    NSPredicate *doneBloodDonationEventsPredicate =
        [NSPredicate predicateWithFormat: @"(SELF isKindOfClass: %@) AND (isDone != YES)",
        [HSBloodDonationEvent class]];
    return [self.bloodRemoteEvents filteredArrayUsingPredicate: doneBloodDonationEventsPredicate];
}

- (NSArray *)bloodRemoteEventsFromEvents: (NSArray *)events {
    THROW_IF_ARGUMENT_NIL(events, @"events is not specified")
    return [events filteredArrayUsingPredicate:
            [NSPredicate predicateWithFormat: @"SELF isKindOfClass: %@", [HSBloodRemoteEvent class]]];
}


- (BOOL)isAfterLastDoneBloodDonationEvent: (HSBloodDonationEvent *)checkedEvent {
    THROW_IF_ARGUMENT_NIL(checkedEvent, @"bloodDonationEvent is not specified");
    for (HSBloodDonationEvent *bloodDonationEvent in [self bloodDonationEvents]) {
        if (bloodDonationEvent.isDone && [checkedEvent.scheduleDate isBeforeDay:bloodDonationEvent.scheduleDate]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isBloodDonationEventAfterRestPeriod: (HSBloodDonationEvent *)bloodDonationEvent {
    THROW_IF_ARGUMENT_NIL(bloodDonationEvent, @"bloodDonationEvent is not specified");
    for (HSFinishRestEvent *finishRestEvent in self.finishRestEvents) {
        if ((bloodDonationEvent.bloodDonationType == finishRestEvent.bloodDonationType) &&
            [bloodDonationEvent.scheduleDate isBeforeDay: finishRestEvent.scheduleDate]) {
            return NO;
        }
    }
    return YES;
}

- (void)removeUndoneBloodDonationEventsOfType:(HSBloodDonationType)bloodDonationType fromDate:(NSDate *)fromDate
                                       toDate:(NSDate *)toDate {
    for (HSBloodDonationEvent *undoneEvent in [self undoneBloodDonationEvents]) {
        if (undoneEvent.bloodDonationType == bloodDonationType &&
                [undoneEvent.scheduleDate isAfterDay:fromDate] && [undoneEvent.scheduleDate isBeforeDay:toDate]) {
            if ([self.bloodRemoteEvents containsObject:undoneEvent]) {
                [self removeBloodRemoteEvent: undoneEvent completion: ^(BOOL success, NSError *error) {
                    if (success) {
                        [self.bloodRemoteEvents removeObject: undoneEvent];
                    } else {
                        #warning Notify user
                        NSLog (@"Unable to remove event due to reason: %@", error);
                    }
                }];
            }
        }
    }
}

@end
