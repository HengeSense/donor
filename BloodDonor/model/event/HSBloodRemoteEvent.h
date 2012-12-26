//
//  HSBloodRemoteEvent.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 23.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSNotificationEvent.h"
#import "HSModelCommon.h"

@class PFObject;

/**
 * This class represents wrapper for the remote event from the parse.com server.
 */
@interface HSBloodRemoteEvent : HSNotificationEvent <NSCopying>

/// @name Remote event creation methods

/**
 * Build concrete blood remote event based on the specified remote event object.
 */
+ (HSBloodRemoteEvent *)buildBloodEventWithRemoteEvent: (PFObject *)remoteEvent;

/// @name Properties

/**
 * Shows the current state of the remote event.
 */
@property (nonatomic, assign) BOOL isDone;

/**
 * Address of blood laboratory.
 */
@property (nonatomic, strong) NSString *labAddress;

/**
 * Comments to the event.
 */
@property (nonatomic, strong) NSString *comments;

/// @name Interacting with remote server.

/**
 * Async saves edited event to the remote server.
 */
- (void)saveWithCompletionBlock: (CompletionBlockType)completion;

/**
 * Async removes edited event from the remote server.
 */
- (void)removeWithCompletionBlock: (CompletionBlockType)completion;


@end
