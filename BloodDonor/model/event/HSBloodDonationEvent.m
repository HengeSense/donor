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
#import "HSFinishRestEvent.h"

#import <Parse/Parse.h>

static NSString * const kRemoteEventFields_BloodDonationType = @"delivery";
static const size_t kRemoteEventFields_BloodDonationType_Platelets = 0;
static const size_t kRemoteEventFields_BloodDonationType_Plasma = 1;
static const size_t kRemoteEventFields_BloodDonationType_Whole = 2;
static const size_t kRemoteEventFields_BloodDonationType_Granulocytes = 3;

static const size_t const REST_PERIODS_TABLE[4][4] =
{
    /*HSBloodDonationType_Blood*/       {60, 30, 30, 30},
    /*HSBloodDonationType_Platelets*/   {30, 14, 14, 30},
    /*HSBloodDonationType_Plasma*/      {14, 14, 14, 14},
    /*HSBloodDonationType_Granulocytes*/{30, 30, 14, 30}
};

@implementation HSBloodDonationEvent

#pragma mark - Initialize
- (id)init {
    if (self = [super init]) {
        [self.remoteEvent setObject: [NSNumber numberWithInt: 1] forKey: @"type"];
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
            break;
        case HSBloodDonationType_Plasma:
            remoteBloodDonationTypeCode = kRemoteEventFields_BloodDonationType_Plasma;
            break;
        case HSBloodDonationType_Blood:
            remoteBloodDonationTypeCode = kRemoteEventFields_BloodDonationType_Whole;
            break;
        case HSBloodDonationType_Granulocytes:
            remoteBloodDonationTypeCode = kRemoteEventFields_BloodDonationType_Granulocytes;
            break;
        default:
            @throw [NSException exceptionWithName: NSInternalInconsistencyException
                                           reason: @"Unexpected type of bloof donation" userInfo: nil];
    }
    [self.remoteEvent setObject: [NSNumber numberWithUnsignedInteger: remoteBloodDonationTypeCode]
                         forKey: kRemoteEventFields_BloodDonationType];
}

- (NSArray *)getFinishRestEvents {
    NSCalendar *systemCalendar = [NSCalendar currentCalendar];
    int dateComponentsUnits = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *beginingDayComponents =
            [systemCalendar components: dateComponentsUnits fromDate: self.scheduledDate];
    
    NSDate *beginingDay = [systemCalendar dateFromComponents: beginingDayComponents];
    
    const size_t kSecondsInDay = 24 * 60 * 60;
    
    NSDate *finishRestDateForBlood =
            [NSDate dateWithTimeInterval: REST_PERIODS_TABLE[self.bloodDonationType][HSBloodDonationType_Blood] * kSecondsInDay
                               sinceDate: beginingDay];
    HSFinishRestEvent *finishRestEventForBlood = [[HSFinishRestEvent alloc] init];
    finishRestEventForBlood.bloodDonationType = HSBloodDonationType_Blood;
    finishRestEventForBlood.scheduledDate = finishRestDateForBlood;
    
    NSDate *finishRestDateForGranulocytes =
            [NSDate dateWithTimeInterval: REST_PERIODS_TABLE[self.bloodDonationType][HSBloodDonationType_Granulocytes] * kSecondsInDay
                               sinceDate: beginingDay];
    HSFinishRestEvent *finishRestEventForGranulocytes = [[HSFinishRestEvent alloc] init];
    finishRestEventForGranulocytes.bloodDonationType = HSBloodDonationType_Granulocytes;
    finishRestEventForGranulocytes.scheduledDate = finishRestDateForGranulocytes;

    NSDate *finishRestDateForPlasma =
            [NSDate dateWithTimeInterval: REST_PERIODS_TABLE[self.bloodDonationType][HSBloodDonationType_Plasma] * kSecondsInDay
                               sinceDate: beginingDay];
    HSFinishRestEvent *finishRestEventForPlasma = [[HSFinishRestEvent alloc] init];
    finishRestEventForPlasma.bloodDonationType = HSBloodDonationType_Plasma;
    finishRestEventForPlasma.scheduledDate = finishRestDateForPlasma;
    
    NSDate *finishRestDateForPlatelets =
            [NSDate dateWithTimeInterval: REST_PERIODS_TABLE[self.bloodDonationType][HSBloodDonationType_Platelets] * kSecondsInDay
                               sinceDate: beginingDay];
    HSFinishRestEvent *finishRestEventForPlatelets = [[HSFinishRestEvent alloc] init];
    finishRestEventForPlatelets.bloodDonationType = HSBloodDonationType_Platelets;
    finishRestEventForPlatelets.scheduledDate = finishRestDateForPlatelets;
    
    return [NSArray arrayWithObjects: finishRestEventForBlood, finishRestEventForGranulocytes,
            finishRestEventForPlasma, finishRestEventForPlatelets, nil];
}

@end
