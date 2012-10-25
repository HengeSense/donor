//
//  HSBloodDonationEvent.m
//  HSBloodDonationEvent
//
//  Created by Sergey Seroshtan on 19.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSBloodDonationEvent.h"
#import "HSBloodRemoteEvent_Protected.h"
#import "HSModelCommon.h"

#import <Parse/Parse.h>

static NSString * const kRemoteEventFields_BloodDonationType = @"delivery";
static const size_t kRemoteEventFields_BloodDonationType_Platelets = 0;
static const size_t kRemoteEventFields_BloodDonationType_Plasma = 1;
static const size_t kRemoteEventFields_BloodDonationType_Whole = 2;
static const size_t kRemoteEventFields_BloodDonationType_Granulocytes = 3;


@implementation HSBloodDonationEvent

#pragma mark - Initialization
- (id)init {
    if (self = [super initWithRemoteEvent: [[PFObject alloc] initWithClassName: kRemoteEvent_BaseClassName]]) {
    
    }
    return self;
}

#pragma mark - Getters / Setters bridget to PFObject class object.
- (HSBloodDonationType)bloodDonationType {
    size_t bloodDonationType = [[self.remoteEvent objectForKey: kRemoteEventFields_BloodDonationType] intValue];
    switch (bloodDonationType) {
        case kRemoteEventFields_BloodDonationType_Platelets:
            return HSBloodDonationType_Platelets;
        case kRemoteEventFields_BloodDonationType_Plasma:
            return HSBloodDonationType_Plasma;
        case kRemoteEventFields_BloodDonationType_Whole:
            return HSBloodDonationType_Blood;
        case kRemoteEventFields_BloodDonationType_Granulocytes:
            return HSBloodDonationType_Granulocytes;
        default:
            @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                           reason: @"Unexpected type of blood donation on remote server" userInfo: nil];
    }
}

- (void)setBloodDonationType: (HSBloodDonationType)bloodDonationType {
    size_t remoteBloodDonationTypeCode = SIZE_T_MAX;
    switch (bloodDonationType) {
        case HSBloodDonationType_Platelets:
            remoteBloodDonationTypeCode = kRemoteEventFields_BloodDonationType_Platelets;
        case HSBloodDonationType_Plasma:
            remoteBloodDonationTypeCode = kRemoteEventFields_BloodDonationType_Plasma;
        case HSBloodDonationType_Blood:
            remoteBloodDonationTypeCode = kRemoteEventFields_BloodDonationType_Whole;
        case HSBloodDonationType_Granulocytes:
            remoteBloodDonationTypeCode = kRemoteEventFields_BloodDonationType_Granulocytes;
        default:
            @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                           reason: @"Unexpected type of bloof donation" userInfo: nil];
    }
    [self.remoteEvent setObject: [NSNumber numberWithUnsignedInteger: remoteBloodDonationTypeCode]
                         forKey: kRemoteEventFields_BloodDonationType];
}

@end
