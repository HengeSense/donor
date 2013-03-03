//
//  HSBloodRemoteEvent.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 23.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSBloodRemoteEvent.h"
#import "HSBloodRemoteEvent+LocalNotification_Protected.h"

#import <Parse/Parse.h>

#import "HSBloodTestsEvent.h"
#import "HSBloodDonationEvent.h"
#import "NSDate+HSCalendar.h"

#pragma mark - Private types
typedef enum {
    HSRemoteEventChildType_BloodTestsType = 0, // this value conforms with remote event representation
    HSRemoteEventChildType_BloodDonationType = 1, // this value conforms with remote event representation
} HSRemoteEventChildType;

#pragma mark - Remote events keys
static NSString * const kRemoteEventField_Address = @"adress";
static NSString * const kRemoteEventField_AnalysisResult = @"analysisResult";
static NSString * const kRemoteEventField_Comment = @"comment";
static NSString * const kRemoteEventField_Date = @"date";
static NSString * const kRemoteEventField_Finished = @"finished";
static NSString * const kRemoteEventFields_Notice = @"notice";
static NSString * const kRemoteEventField_ReminderDate = @"reminderDate";
static NSString * const kRemoteEventField_ReminderMessage = @"reminderMessage";
static NSString * const kRemoteEventField_Station = @"station";
static NSString * const kRemoteEventField_Title = @"title";
static NSString * const kRemoteEventField_Type = @"type";

#pragma mark - Local notification keys
static NSString * const kLocalNotificationUserInfoKey_ID = @"remoteObectId";

#pragma mark - Private section declaration
@interface HSBloodRemoteEvent ()

/**
 * Contains reference to the remote event object representation.
 */
@property (nonatomic, strong, readwrite) PFObject *remoteEvent;
@end

@implementation HSBloodRemoteEvent

#pragma mark - Creation methods 
+ (HSBloodRemoteEvent *)buildBloodEventWithRemoteEvent:(PFObject *)remoteEvent {
    THROW_IF_ARGUMENT_NIL(remoteEvent, @"remote event is not specified");
    int bloodEventType = [[remoteEvent objectForKey: kRemoteEventField_Type] intValue];
    switch (bloodEventType) {
        case HSRemoteEventChildType_BloodTestsType:
            return [[HSBloodTestsEvent alloc] initWithRemoteEvent: remoteEvent];
        case HSRemoteEventChildType_BloodDonationType:
            return [[HSBloodDonationEvent alloc] initWithRemoteEvent: remoteEvent];
        default:
            // unsupported remote event
            return nil;
    }
}

#pragma mark - Properties custom implemetation (delegation to the self.remoteObject)
- (BOOL)isDone {
    return [[self.remoteEvent objectForKey: kRemoteEventField_Finished] boolValue];
}

- (void)setIsDone:(BOOL)isDone {
    [self.remoteEvent setObject: [NSNumber numberWithBool: isDone] forKey: kRemoteEventField_Finished];
}

- (NSDate *)scheduleDate {
    return [self.remoteEvent objectForKey: kRemoteEventField_Date];
}

- (void) setScheduleDate: (NSDate *)scheduledDate {
    [self.remoteEvent setObject: scheduledDate forKey: kRemoteEventField_Date];
}

- (NSString *)labAddress {
    return [self.remoteEvent objectForKey: kRemoteEventField_Address];
}

- (void) setLabAddress: (NSString *)labAddress {
    [self.remoteEvent setObject: labAddress forKey: kRemoteEventField_Address];
}

- (NSDate *)notificationDate {
    return [self.remoteEvent objectForKey: kRemoteEventField_ReminderDate];
}

- (void)setNotificationDate: (NSDate *)notificationDate {
    [self.remoteEvent setObject: notificationDate forKey: kRemoteEventField_ReminderDate];
}

- (NSString *)notificationMessage {
    return [self.remoteEvent objectForKey: kRemoteEventField_ReminderMessage];
}

- (void)setNotificationMessage:(NSString *)notificationMessage {
    [self.remoteEvent setObject: notificationMessage forKey: kRemoteEventField_ReminderMessage];
}

- (void)setComments: (NSString *)comments {
    [self.remoteEvent setObject: comments forKey: kRemoteEventField_Comment];
}

- (NSString *)comments {
    return [self.remoteEvent objectForKey: kRemoteEventField_Comment];
}


#pragma mark - Initialization
- (id)init {
    PFObject *newEvent = [[PFObject alloc] initWithClassName: kRemoteEvent_BaseClassName];
    
    if([self isKindOfClass: [HSBloodDonationEvent class]]) {
        [newEvent setObject: [NSNumber numberWithInt: HSRemoteEventChildType_BloodDonationType]
                     forKey: kRemoteEventField_Type];

    } else if ([self isKindOfClass: [HSBloodTestsEvent class]]) {
        [newEvent setObject: [NSNumber numberWithInt: HSRemoteEventChildType_BloodTestsType]
                     forKey: kRemoteEventField_Type];
    }
    
    if (self = [self initWithRemoteEvent: newEvent]) {
        self.scheduleDate = [NSDate date];
        self.isDone = NO;
    }
    return self;
}

- (id)initWithRemoteEvent:(PFObject *)remoteEvent {
    THROW_IF_ARGUMENT_NIL(remoteEvent, @"remote event is not specified");
    if (self = [super init]) {
        self.remoteEvent = remoteEvent;
    }
    return self;
}

#pragma mark - Interaction with server side.
- (void)saveWithCompletionBlock: (CompletionBlockType)completion {
    THROW_IF_ARGUMENT_NIL(completion, @"completion block is not defined");

    [self.remoteEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFUser *currentUser = [PFUser currentUser];
            PFRelation *eventsRelation = [currentUser relationforKey:@"events"];
            
            [eventsRelation addObject: self.remoteEvent];
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                completion(succeeded, error);
            }];
        } else {
            completion(succeeded, error);
        }
    }];
 }

- (void)removeWithCompletionBlock: (CompletionBlockType)completion {
    THROW_IF_ARGUMENT_NIL(completion, @"completion block is not defined");
    // Sync deletion is used because async deletion crashes the application.
    NSError *deleteError = nil;
    BOOL succeed = [self.remoteEvent delete: &deleteError];
    completion(succeed, deleteError);
}

#pragma mark - NSCopying protocol implementation
- (id)copyWithZone:(NSZone *)__unused zone {
    HSBloodRemoteEvent *event = [[[self class] alloc] init];
    event.isDone = self.isDone;
    if (self.scheduleDate != nil) {
        event.scheduleDate = self.scheduleDate;
    }
    if (self.labAddress != nil) {
        event.labAddress = self.labAddress;
    }
    if (self.notificationDate != nil) {
        event.notificationDate = self.notificationDate;
    }
    if (self.notificationMessage != nil) {
        event.notificationMessage = self.notificationMessage;
    }
    if (self.comments != nil) {
        event.comments = self.comments;
    }
    return event;
}

- (void)scheduleConfirmationLocalNotificationAtDate:(NSDate *)fireDate {
    
    // Set default value
    NSDate *correctedFireDate = [self.scheduleDate dateMovedToHour:17 minute:00];
    if (fireDate != nil) {
        correctedFireDate = fireDate;
    } else if (self.localNotificationFireDate != nil) {
        correctedFireDate = self.localNotificationFireDate;
    }

    NSDictionary *userInfo = @{kLocalNotificationUserInfoKey_ClassName : NSStringFromClass(self.class),
                               kLocalNotificationUserInfoKey_ID : self.remoteEvent.objectId};
    
    [super scheduleLocalNotificationAtDate:correctedFireDate withAlertAction:kNotificationEventAlertActionDefault
            alertBody:[self alertBodyForConfirmationLocalNotification] userInfo:userInfo];
}

- (void)scheduleReminderLocalNotificationAtDate:(NSDate *)fireDate {
    
    // Set default value
    NSDate *correctedFireDate = [[self.scheduleDate dayBefore] dateMovedToHour:12 minute:00];
    if (fireDate != nil) {
        correctedFireDate = fireDate;
    } else if (self.localNotificationFireDate != nil) {
        correctedFireDate = self.localNotificationFireDate;
    }

    NSDictionary *userInfo = @{kLocalNotificationUserInfoKey_ClassName : NSStringFromClass(self.class),
                               kLocalNotificationUserInfoKey_ID : self.remoteEvent.objectId};
    
    [super scheduleLocalNotificationAtDate:correctedFireDate withAlertAction:kNotificationEventAlertActionDefault
            alertBody:[self alertBodyForReminderLocalNotification] userInfo:userInfo];
}

- (void)cancelScheduledLocalNotification {
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSPredicate *idPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        UILocalNotification *candidate = evaluatedObject;
        NSString *className = [candidate.userInfo objectForKey:kLocalNotificationUserInfoKey_ClassName];
        NSString *objectId = [candidate.userInfo objectForKey:kLocalNotificationUserInfoKey_ID];
        return [className isEqualToString:NSStringFromClass(self.class)] &&
                [objectId isEqualToString:self.remoteEvent.objectId];
    }];
    NSArray *localNotificationsForDeletion = [localNotifications filteredArrayUsingPredicate:idPredicate];
    for (UILocalNotification *forDeletion in localNotificationsForDeletion) {
        [[UIApplication sharedApplication] cancelLocalNotification:forDeletion];
    }
}

@end
