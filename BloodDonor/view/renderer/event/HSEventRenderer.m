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
#import "HSTimetableModifierEvent.h"

#import "HSBloodDonationEventRenderer.h"
#import "HSBloodTestsEventRenderer.h"
#import "HSFinishRestEventRenderer.h"
#import "HSTimetableModifierEventRenderer.h"

@implementation HSEventRenderer

+ (HSEventRenderer *)createEventRendererForEvent: (HSEvent *)event {
    THROW_IF_ARGUMENT_NIL(event, @"event is not specified");
    HSEventRenderer *resultEventRenderer = nil;
    if ([event isKindOfClass: [HSBloodDonationEvent class]]) {
        resultEventRenderer = [[HSBloodDonationEventRenderer alloc] init];
    } else if ([event isKindOfClass: [HSFinishRestEvent class]]) {
        resultEventRenderer = [[HSFinishRestEventRenderer alloc] init];
    } else if ([event isKindOfClass: [HSTimetableModifierEvent class]]) {
        resultEventRenderer = [[HSTimetableModifierEventRenderer alloc] init];
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
