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
 * Removes all finish rest events from the specified date, including specified date.
 */
- (void)removeAllFinishRestEventsAfterDate: (NSDate *)date;

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
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *dayDateComponents =
            [currentCalendar components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                               fromDate: dayDate];
    NSDate *roundedDayDate = [currentCalendar dateFromComponents: dayDateComponents];
    
    NSArray *allEvents = [self allEvents];
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
    NSArray *resultEvents = [allEvents filteredArrayUsingPredicate: eventsBetweenDates];
    return resultEvents;
}

- (NSUInteger)numberOfDoneBloodDonationEvents {
    return [[self doneBloodDonationEvents] count];
}

#pragma mark - Remote events manipulation methods
- (void)addBloodRemoteEvent: (HSBloodRemoteEvent *)bloodRemoteEvent completion: (CompletionBlockType)completion {
    THROW_IF_ARGUMENT_NIL(bloodRemoteEvent, @"bloodRemoteEvent is not specified");
    NSError *addError = nil;
    if([self canAddBloodRemoteEvent: bloodRemoteEvent error: &addError]) {
        [bloodRemoteEvent saveWithCompletionBlock:^(BOOL success, NSError *error) {
            if (success) {
                if (![self.bloodRemoteEvents containsObject: bloodRemoteEvent]) {
                    [self.bloodRemoteEvents addObject: bloodRemoteEvent];
                }
            }
            if (completion != nil) {
                NSError *localError = [NSError errorWithDomain: HSRemoteServerResonseErrorDomain code: 0 userInfo: nil];
                completion(success, localError);
            }
        }];
    } else {
        if (completion != nil) {
            completion(NO, addError);
        }
    }
}

- (void)removeBloodRemoteEvent:(HSBloodRemoteEvent *)bloodRemoteEvent completion:(CompletionBlockType)completion {
    THROW_IF_ARGUMENT_NIL(bloodRemoteEvent, @"bloodRemoteEvent is not specified");
    if ([self.bloodRemoteEvents containsObject: bloodRemoteEvent]) {
        [bloodRemoteEvent removeWithCompletionBlock:^(BOOL success, NSError *error) {
            if (success) {
                [self.bloodRemoteEvents removeObject: bloodRemoteEvent];
                [self updateFinishRestEvents];
                if (completion != nil) {
                    completion(success, error);
                }
            } else {
                NSError *localError = [NSError errorWithDomain: HSRemoteServerResonseErrorDomain code: 0 userInfo: nil];
                if (completion != nil) {
                    completion(NO, localError);
                }
            }
        }];
        
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
            [self addFinishRestEvents];
            BOOL success = error == nil ? YES : NO;
            completion(success, error);
        }];
    } else {
        @throw [HSCalendarException exceptionWithName: HSCalendarExceptionUserUnauthorized
                reason: @"User is not authorized yet. Calendar can't be used." userInfo: nil];
    }
}

- (void)pushEventsToServer: (CompletionBlockType)completion {
    __block size_t unsavedRemoteObjectsCount = self.bloodRemoteEvents.count;
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
    for (HSBloodRemoteEvent *remoteBloodEvent in self.bloodRemoteEvents) {
        [remoteBloodEvent saveWithCompletionBlock: partialCompletion];
    }
}

-(void)addFinishRestEvents {
    [self.finishRestEvents removeAllObjects];
    
    NSArray *orderedDoneBloodDonationEvents = [[self doneBloodDonationEvents]
            sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        HSBloodDonationEvent *first = obj1;
        HSBloodDonationEvent *second = obj2;
        if (first.scheduledDate.timeIntervalSince1970 < second.scheduledDate.timeIntervalSince1970) {
            return NSOrderedAscending;
        } else if (first.scheduledDate.timeIntervalSince1970 > second.scheduledDate.timeIntervalSince1970) {
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
                                               fromDate:lastDoneBloodDonationEvent.scheduledDate
                                                 toDate:finishRestEvent.scheduledDate];
        }
        
        [self.finishRestEvents addObjectsFromArray: finishRestEvents];
    }
    
    
}

- (void)updateFinishRestEvents {
    [self.finishRestEvents removeAllObjects];
    [self addFinishRestEvents];
}

#pragma mark - Utility methods
- (void)removeAllFinishRestEventsAfterDate: (NSDate *)date {
    THROW_IF_ARGUMENT_NIL(date, @"date is not specified");
    NSCalendar *systemCalendar = [NSCalendar currentCalendar];
    int dateComponentsUnits = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit |
            NSMinuteCalendarUnit;
    NSDateComponents *yesterdayComponents = [systemCalendar components: dateComponentsUnits fromDate: date];
    --yesterdayComponents.day;
    yesterdayComponents.hour = 23;
    yesterdayComponents.minute = 59;
    
    NSDate *yesterday = [systemCalendar dateFromComponents: yesterdayComponents];
    
    NSMutableArray *eventsToDelete = [[NSMutableArray alloc] init];
    for (HSFinishRestEvent *event in self.finishRestEvents) {
        if (event.scheduledDate.timeIntervalSince1970 > yesterday.timeIntervalSince1970) {
            [eventsToDelete addObject: event];
        }
    }
    
    [self.finishRestEvents removeObjectsInArray: eventsToDelete];
}
 
- (BOOL)canAddBloodRemoteEvent: (HSBloodRemoteEvent *)bloodRemoteEvent error: (NSError **)error {
    THROW_IF_ARGUMENT_NIL(bloodRemoteEvent, @"bloodRemoteEvent is not specified");    
    NSArray *eventsInTheSameDay = [self eventsForDay: bloodRemoteEvent.scheduledDate];
    NSArray *remoteEventsInTheSameDay = [eventsInTheSameDay filteredArrayUsingPredicate:
            [NSPredicate predicateWithFormat: @"SELF isKindOfClass: %@", [HSBloodRemoteEvent class]]];
    BOOL isFreeDay = remoteEventsInTheSameDay.count == 0;
    if (isFreeDay) {
        if ([bloodRemoteEvent isKindOfClass: [HSBloodTestsEvent class]]) {
            return YES;
        } else {
            HSBloodDonationEvent *bloodDonationEvent = (HSBloodDonationEvent *)bloodRemoteEvent;
            if ([self isLatestDoneBloodDonationEvent: bloodDonationEvent] &&
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
    } else if ([remoteEventsInTheSameDay objectAtIndex: 0] == bloodRemoteEvent) {
        if ([bloodRemoteEvent isKindOfClass: [HSBloodTestsEvent class]]) {
            return YES;
        } else {
            HSBloodDonationEvent *bloodDonationEvent = (HSBloodDonationEvent *)bloodRemoteEvent;
            // Before next checks this event should be deleted  from the self.bloodRemoteEvents array.
            [self.bloodRemoteEvents removeObject: bloodDonationEvent];
            [self updateFinishRestEvents];
            @try {
                if ([self isLatestDoneBloodDonationEvent: bloodDonationEvent] &&
                    [self isBloodDonationEventAfterRestPeriod: bloodDonationEvent]) {
                    return YES;
                } else {
                    if (error != NULL) {
                        *error = [[NSError alloc] initWithDomain: HSCalendarAddEventErrorDomain
                                code: HSCalendarAddEventErrorDomainCode_RestPeriodNotFinished userInfo: nil];
                    }
                    return NO;
                }
            } @finally {
                // Restore removed object naytime 
                [self.bloodRemoteEvents addObject: bloodDonationEvent];
                [self updateFinishRestEvents];
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


- (BOOL)isLatestDoneBloodDonationEvent: (HSBloodDonationEvent *)bloodDonationEvent {
    THROW_IF_ARGUMENT_NIL(bloodDonationEvent, @"bloodDonationEvent is not specified");
    NSArray *bloodDonationEvents;
    bloodDonationEvents = [self bloodDonationEvents];

    for (HSBloodDonationEvent *bloodDonationEvent in bloodDonationEvents) {
        if (bloodDonationEvent.isDone && bloodDonationEvent.scheduledDate.timeIntervalSince1970 >
                bloodDonationEvent.scheduledDate.timeIntervalSince1970) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isBloodDonationEventAfterRestPeriod: (HSBloodDonationEvent *)bloodDonationEvent {
    THROW_IF_ARGUMENT_NIL(bloodDonationEvent, @"bloodDonationEvent is not specified");
    for (HSFinishRestEvent *finishRestEvent in self.finishRestEvents) {
        if ((bloodDonationEvent.bloodDonationType == finishRestEvent.bloodDonationType) &&
            [bloodDonationEvent.scheduledDate isBeforeDay: finishRestEvent.scheduledDate]) {
            return NO;
        }
    }
    return YES;
}

- (void)removeUndoneBloodDonationEventsOfType:(HSBloodDonationType)bloodDonationType fromDate:(NSDate *)fromDate
                                       toDate:(NSDate *)toDate {
    for (HSBloodDonationEvent *undoneEvent in [self undoneBloodDonationEvents]) {
        if (undoneEvent.bloodDonationType == bloodDonationType &&
                [undoneEvent.scheduledDate isAfterDay:fromDate] && [undoneEvent.scheduledDate isBeforeDay:toDate]) {
            [self.bloodRemoteEvents removeObject: undoneEvent];
        }
    }
}

@end
