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
    THROW_IF_ARGUMENT_NIL(remoteEvent);
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
    THROW_IF_ARGUMENT_NIL(remoteEvent);
    if (self = [super init]) {
        self.remoteEvent = remoteEvent;
    }
    return self;
}

#pragma mark - Interaction with server side.
- (void)saveWithCompletionBlock: (CompletionBlockType)completion {
    THROW_IF_ARGUMENT_NIL(completion);

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
    THROW_IF_ARGUMENT_NIL(completion);
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
    if (self.reminderFireDate != nil) {
        event.reminderFireDate = self.reminderFireDate;
    } else {
        event.reminderFireDate = [self reminderFireDateDefault];
    }
    return event;
}

#pragma mark - HSNotificationEvent protected interface implementation
- (NSDate *)reminderFireDateDefault {
    // As default behaviour no remider notification should be scheduled for this event.
    return nil;
}

- (NSDate *)confirmationFireDateDefault {
    return [self.scheduleDate dateMovedToHour:17 minute:00];
}

- (void)scheduleConfirmationLocalNotification {
    if ([self hasScheduledConfirmationLocalNotification]) {
        return;
    }
    
    // Set default value
    NSDate *fireDate = [self confirmationFireDateDefault];
    
    [super scheduleLocalNotificationAtDate:fireDate withAlertAction:kNotificationEventAlertActionDefault
            alertBody:[self alertBodyForConfirmationLocalNotification]
            userInfo:[self confirmationLocalNotificationBaseUserInfo]];
}

- (void)scheduleReminderLocalNotificationAtDate:(NSDate *)fireDate {
    if ([self hasScheduledReminderLocalNotification]) {
        return;
    }
    
    // Set default value
    NSDate *correctedFireDate = [self reminderFireDateDefault];
    if (fireDate != nil) {
        correctedFireDate = fireDate;
    } else if (self.reminderFireDate != nil) {
        correctedFireDate = self.reminderFireDate;
    }
    self.reminderFireDate = correctedFireDate;
    
    if (self.reminderFireDate != nil) {
        NSUInteger minutesLeft =
                (self.scheduleDate.timeIntervalSince1970 - self.reminderFireDate.timeIntervalSince1970) / 60;
        [super scheduleLocalNotificationAtDate:correctedFireDate withAlertAction:kNotificationEventAlertActionDefault
                alertBody:[self alertBodyForReminderLocalNotificationWithMinutesLeft:minutesLeft]
                userInfo:[self reminderLocalNotificationBaseUserInfo]];
    }
}

#pragma mark - HSUIDProvider protocol implementation
- (NSUInteger)uid {
    NSUInteger prime = 31;
    NSUInteger result = [super uid];
    
    result = prime * result + [self.remoteEvent.objectId hash];
    
    return result;
}


@end
