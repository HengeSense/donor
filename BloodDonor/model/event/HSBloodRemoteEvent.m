//
//  HSBloodRemoteEvent.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 23.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSBloodRemoteEvent.h"

#import <Parse/Parse.h>

#import "HSBloodTestsEvent.h"
#import "HSBloodDonationEvent.h"

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

- (NSDate *)scheduledDate {
    return [self.remoteEvent objectForKey: kRemoteEventField_Date];
}

- (void) setScheduledDate: (NSDate *)scheduledDate {
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
        self.scheduledDate = [NSDate date];
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
    [self.remoteEvent deleteInBackgroundWithBlock: ^(BOOL succeeded, NSError *error) {
        completion(succeeded, error);
    }];
}

@end
