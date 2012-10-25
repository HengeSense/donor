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

