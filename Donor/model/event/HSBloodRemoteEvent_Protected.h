//
//  HSBloodRemoteEvent_Protected.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 24.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#ifndef BloodDonor_HSBloodRemoteEvent_Protected_h
#define BloodDonor_HSBloodRemoteEvent_Protected_h

#import "HSBloodRemoteEvent.h"

@interface HSBloodRemoteEvent ()

/// @name Properties

/**
 * Contains reference to the remote event object representation.
 */
@property (nonatomic, strong, readonly) PFObject *remoteEvent;

/// @name Initialization

/**
 * This initializer is used for creation local event from the remote event.
 */
- (id)initWithRemoteEvent: (PFObject *)remoteEvent;
@end

#endif
