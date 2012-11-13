//
//  HSModelCommon.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 24.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

/// @name Common model types

/**
 * Completion block of code. Invoked after asynch operation completion.
 */
typedef void(^CompletionBlockType)(BOOL success, NSError *error);

/// @name Remote model constants
extern NSString * const kRemoteEvent_BaseClassName;

/// @name Error domains
extern NSString * const HSRemoteServerResponseErrorDomain;

/**
 * This domain errors may occur during add avant to the calendar
 */
extern NSString * const HSCalendarAddEventErrorDomain;

typedef enum {
    HSCalendarAddEventErrorDomainCode_RestPeriodNotFinished = 0,
    HSCalendarAddEventErrorDomainCode_DayIsBusy,
    HSCalendarAddEventErrorDomainCode_BeforeFirstDonation
} HSCalendarAddEventErrorDomainCode;

NSString* localizedDescriptionForError (NSError *error);
