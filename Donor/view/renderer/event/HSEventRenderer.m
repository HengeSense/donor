//
//  HSEventRenderer.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 22.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSEventRenderer.h"

#import "HSBloodDonationEvent.h"
#import "HSBloodTestsEvent.h"
#import "HSFinishRestEvent.h"
#import "HSDayPurposeModifierEvent.h"

#import "HSBloodDonationEventRenderer.h"
#import "HSBloodTestsEventRenderer.h"
#import "HSFinishRestEventRenderer.h"

@implementation HSEventRenderer

+ (HSEventRenderer *)createEventRendererForEvent: (HSEvent *)event {
    THROW_IF_ARGUMENT_NIL(event);
    HSEventRenderer *resultEventRenderer = nil;
    if ([event isKindOfClass: [HSBloodDonationEvent class]]) {
        resultEventRenderer = [[HSBloodDonationEventRenderer alloc] init];
    } else if ([event isKindOfClass: [HSFinishRestEvent class]]) {
        resultEventRenderer = [[HSFinishRestEventRenderer alloc] init];
    } else if ([event isKindOfClass: [HSBloodTestsEvent class]]) {
        resultEventRenderer = [[HSBloodTestsEventRenderer alloc] init];
    } else {
        resultEventRenderer = [[HSEventRenderer alloc] init];
    }
    resultEventRenderer.event = event;
    return resultEventRenderer;
}

- (UIView *)renderViewInBounds: (CGRect)bounds {
    return [[UIView alloc] initWithFrame: bounds];
}

@end
