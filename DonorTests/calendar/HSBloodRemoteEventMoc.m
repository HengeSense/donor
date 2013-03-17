//
//  HSBloodRemoteEventMoc.m
//  Donor
//
//  Created by Sergey Seroshtan on 17.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSBloodRemoteEventMoc.h"

@implementation HSBloodRemoteEventMoc

- (void)saveWithCompletionBlock:(CompletionBlockType)completion {
    LOG_MOCKED_METHOD_INVOCATION;
    if (completion) {
        completion(YES, nil);
    }
}

- (void)removeWithCompletionBlock:(CompletionBlockType)completion {
    LOG_MOCKED_METHOD_INVOCATION;
    if (completion) {
        completion(YES, nil);
    }
}

@end
